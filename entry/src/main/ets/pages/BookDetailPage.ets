import BookModel from '../model/BookModel';
import { ReadingStatusService, ReadingStatus } from '../model/ReadingStatusService';
import { FavoritesService } from '../model/FavoritesService';
import { BookHistoryService } from '../model/BookHistoryService';
import { BookViewModel } from '../viewmodel/BookViewModel';
import { statusBackgroundColor, statusTextColor } from '../utils/ReadingStatusStyle';

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
    if (this.pathStack.getParamByName('BookDetailPage').length === 0) {
      this.pathStack.pop();
      return;
    }
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
    const all: ReadingStatus[] = [
      ReadingStatus.NONE,
      ReadingStatus.TO_READ,
      ReadingStatus.READING,
      ReadingStatus.READ
    ]
    const next = all[(all.indexOf(this.readingStatus) + 1) % all.length]
    ReadingStatusService.getInstance().setStatus(book.id, next)
    this.readingStatus = next
  }

  private metaText(book: BookModel): string {
    const category = book.categories && book.categories.length > 0 ? book.categories[0] : 'Book'
    const year = book.publishedDate ? book.publishedDate.slice(0, 4) : ''
    if (year && book.pageCount > 0) {
      return `${category} · ${year} · ${book.pageCount} pages`
    }
    if (book.pageCount > 0) {
      return `${category} · ${book.pageCount} pages`
    }
    return category
  }

  build() {
    NavDestination() {
      Swiper() {
        ForEach(this.books, (book: BookModel) => {
          this.bookView(book)
        }, (item: BookModel) => item.id || item.previewLink || item.title)
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
    Column() {
      Row() {
        Column() {
          Text(this.isFavorite ? '❤️' : '🤍')
            .fontSize(18)
            .width(36)
            .height(30)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              FavoritesService.getInstance().toggleFavorite(book)
              this.isFavorite = FavoritesService.getInstance().isFavorite(book.id)
            })
        }
        .width(86)
        .height(104)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.End)

        Column() {
          Image(book.image)
            .height(84)
            .width(64)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
        }
        .width(64)
        .height(104)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)

        Column() {
          if (this.fromSearch) {
            Text('+ Add')
              .fontSize(11)
              .fontColor('#4A90E2')
              .fontWeight(FontWeight.Medium)
              .width(68)
              .height(28)
              .textAlign(TextAlign.Center)
              .backgroundColor('#0D1A33')
              .borderRadius(12)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .onClick(() => {
                BookViewModel.instance.addBook(book)
                this.fromSearch = false
              })
          } else {
            Text(this.readingStatus === ReadingStatus.NONE ? 'Status' : this.readingStatus)
              .fontSize(11)
              .fontColor(statusTextColor(this.readingStatus))
              .fontWeight(FontWeight.Medium)
              .width(68)
              .height(28)
              .textAlign(TextAlign.Center)
              .backgroundColor(statusBackgroundColor(this.readingStatus))
              .borderRadius(12)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .onClick(() => {
                this.cycleStatus(book)
              })
          }
        }
        .width(86)
        .height(104)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.End)
        .padding({ left: 10 })
      }
      .width(236)
      .height(110)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 8 })

      Text(book.title)
        .fontSize(12)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .lineHeight(16)
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('68%')
        .margin({ top: 5 })

      if (book.authors && book.authors.length > 0) {
        Text(book.authors[0])
          .fontSize(11)
          .fontColor('#888888')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .width('66%')
          .margin({ top: 4 })
      }

      Text(this.metaText(book))
        .fontSize(10)
        .fontColor('#4A90E2')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width('68%')
        .margin({ top: 5 })

      Text(book.publisher || book.language.toUpperCase() || 'Book details')
        .fontSize(10)
        .fontColor('#666666')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width('64%')
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#000000')
  }
}
