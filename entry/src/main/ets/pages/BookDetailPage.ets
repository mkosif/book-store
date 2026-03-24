import BookModel from '../model/BookModel';
import { ReadingStatusService, ReadingStatus } from '../model/ReadingStatusService';
import { FavoritesService } from '../model/FavoritesService';
import { BookHistoryService } from '../model/BookHistoryService';
import { BookViewModel } from '../viewmodel/BookViewModel';

@Builder
export function BookDetailPageBuilder() {
  BookDetailPage()
}

@Entry
@Component
struct BookDetailPage {
  @Consume('mainStack') pathStack: NavPathStack
  @State readingStatus: ReadingStatus = ReadingStatus.NONE
  @State isFavorite: boolean = false
  @State currentBookIndex: number = 0
  @State books: BookModel[] = []
  @State fromSearch: boolean = false

  aboutToAppear(): void {
    if (this.pathStack.getParamByName('BookDetailPage').length === 0) { this.pathStack.pop(); return; }
    const param = this.pathStack.getParamByName('BookDetailPage')[0] as BookModel
    const idx = BookViewModel.instance.filteredBooks.findIndex(b => b.id === param.id)
    if (idx >= 0) {
      this.fromSearch = false
      this.books = BookViewModel.instance.filteredBooks
      this.currentBookIndex = idx
    } else {
      this.fromSearch = true
      this.books = [param]
      this.currentBookIndex = 0
    }
    this.updateState(param)
  }

  updateState(book: BookModel) {
    this.readingStatus = ReadingStatusService.getInstance().getStatus(book.id)
    this.isFavorite = FavoritesService.getInstance().isFavorite(book.id)
    BookHistoryService.getInstance().addToHistory(book)
  }

  cycleStatus(book: BookModel) {
    const all: ReadingStatus[] = [ReadingStatus.NONE, ReadingStatus.TO_READ, ReadingStatus.READING, ReadingStatus.READ]
    const next = all[(all.indexOf(this.readingStatus) + 1) % all.length]
    ReadingStatusService.getInstance().setStatus(book.id, next)
    this.readingStatus = next
  }

  build() {
    NavDestination() {
      Swiper() {
        ForEach(this.books, (book: BookModel) => {
          this.bookView(book)
        }, (item: BookModel) => item.title + item.previewLink)
      }
      .index(this.currentBookIndex)
      .onChange((index: number) => {
        this.updateState(this.books[index])
      })
      .loop(false)
      .indicator(false)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor('#000000')
  }

  @Builder
  bookView(book: BookModel) {
    Stack() {
      // Centered content
      Column() {
        // Top bar: back | status | fav
        Row() {
          Text('‹')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .width(36).height(36)
            .textAlign(TextAlign.Center)
            .backgroundColor('#444444')
            .borderRadius(18)
            .onClick(() => { this.pathStack.pop() })

          if (this.fromSearch) {
            Text('+ Add')
              .fontSize(10)
              .fontColor('#4A90E2')
              .backgroundColor('#0D1A33')
              .borderRadius(8)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .onClick(() => {
                BookViewModel.instance.addBook(book)
                this.fromSearch = false
              })
          } else {
            Text(this.readingStatus === ReadingStatus.NONE ? '— Status' : this.readingStatus)
              .fontSize(10)
              .fontColor('#4A90E2')
              .backgroundColor('#0D1A33')
              .borderRadius(8)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .onClick(() => { this.cycleStatus(book) })
          }

          Text(this.isFavorite ? '❤️' : '🤍')
            .fontSize(22)
            .width(36).height(36)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              FavoritesService.getInstance().toggleFavorite(book)
              this.isFavorite = FavoritesService.getInstance().isFavorite(book.id)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 36, right: 36, top: 16 })

        // Book content
        Column() {
          Image(book.image)
            .height(80)
            .width(60)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)

          Text(book.title)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ left: 36, right: 36 })
            .margin({ top: 10 })

          if (book.authors && book.authors.length > 0) {
            Text(book.authors[0])
              .fontSize(10)
              .fontColor('#888888')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: 36, right: 36 })
              .margin({ top: 4 })
          }
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .padding({ bottom: 24 })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}
