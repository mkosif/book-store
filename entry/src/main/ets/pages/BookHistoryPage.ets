import { BookCardComponent } from '../component/BookCardComponent'
import BookModel from '../model/BookModel';
import { BookHistoryService } from '../model/BookHistoryService';
import { ReadingStatusService } from '../model/ReadingStatusService';

@Builder
export function BookHistoryPageBuilder() {
  BookHistoryPage()
}

@Entry
@Component
struct BookHistoryPage {
  @State history: BookModel[] = []
  @Consume('mainStack') pathStack: NavPathStack;

  aboutToAppear() {
    this.history = BookHistoryService.getInstance().getHistory();
  }

  onPageShow() {
    this.history = BookHistoryService.getInstance().getHistory();
  }

  build() {
    NavDestination() {
      Column() {
        if (this.history.length === 0) {
          Column() {
            Text('🕐').fontSize(32).margin({ bottom: 12 })
            Text('No history yet').fontSize(12).fontColor('#666666')
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          Scroll() {
            Column() {
              ForEach(this.history, (book: BookModel) => {
                BookCardComponent({
                  image: book.image,
                  title: book.title,
                  pageCount: book.pageCount,
                  categories: book.categories,
                  authors: book.authors,
                  readingStatus: ReadingStatusService.getInstance().getStatus(book.id)
                })
                .margin({ bottom: 6 })
                .onClick(() => {
                  this.pathStack.pushPath({ name: 'BookDetailPage', param: book })
                })
              }, (item: BookModel) => `${item.title}${item.previewLink}`)
            }
            .padding({ left: 12, right: 12, top: 4, bottom: 20 })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
    .hideTitleBar(true)
    .backgroundColor('#000000')
  }
}
