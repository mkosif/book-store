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

  aboutToAppear(): void {
    const param = this.pathStack.getParamByName('BookDetailPage')[0] as BookModel
    this.currentBookIndex = BookViewModel.instance.filteredBooks.findIndex(b => b.title === param.title)
    this.updateState(param)
  }

  updateState(book: BookModel) {
    this.readingStatus = ReadingStatusService.getInstance().getStatus(book.title)
    this.isFavorite = FavoritesService.getInstance().isFavorite(book.title)
    BookHistoryService.getInstance().addToHistory(book)
  }

  cycleStatus(book: BookModel) {
    const all: ReadingStatus[] = [ReadingStatus.NONE, ReadingStatus.TO_READ, ReadingStatus.READING, ReadingStatus.READ]
    const next = all[(all.indexOf(this.readingStatus) + 1) % all.length]
    ReadingStatusService.getInstance().setStatus(book.title, next)
    this.readingStatus = next
  }

  build() {
    NavDestination() {
      Swiper() {
        ForEach(BookViewModel.instance.filteredBooks, (book: BookModel) => {
          this.bookView(book)
        }, (item: BookModel) => item.title + item.previewLink)
      }
      .index(this.currentBookIndex)
      .onChange((index: number) => {
        this.updateState(BookViewModel.instance.filteredBooks[index])
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
        // Back button — top left
        Row() {
          Text('‹')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .width(40)
            .height(40)
            .textAlign(TextAlign.Center)
            .backgroundColor('#444444')
            .borderRadius(20)
            .onClick(() => { this.pathStack.pop() })
        }
        .width('100%')
        .padding({ left: 28, top: 12 })

        // Book content — centered in remaining space
        Column() {
          Image(book.image)
            .height(90)
            .width(68)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)

          Text(book.title)
            .fontSize(13)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ left: 40, right: 40 })
            .margin({ top: 10 })

          if (book.authors && book.authors.length > 0) {
            Text(book.authors[0])
              .fontSize(10)
              .fontColor('#888888')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: 40, right: 40 })
              .margin({ top: 4 })
          }

          Row() {
            Text(this.isFavorite ? '❤️' : '🤍')
              .fontSize(22)
              .padding({ left: 4, right: 8 })
              .onClick(() => {
                FavoritesService.getInstance().toggleFavorite(book)
                this.isFavorite = FavoritesService.getInstance().isFavorite(book.title)
              })

            Blank()

            Text(this.readingStatus === ReadingStatus.NONE ? '— Status' : this.readingStatus)
              .fontSize(10)
              .fontColor('#4A90E2')
              .backgroundColor('#0D1A33')
              .borderRadius(8)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .onClick(() => { this.cycleStatus(book) })
          }
          .width('68%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 14 })
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .layoutWeight(1)
        .padding({ top: 10, bottom: 30 })
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
