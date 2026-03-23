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

  build() {
    NavDestination() {
      Column() {
        if (this.history.length === 0) {
          Text('No history yet.')
            .fontSize(16)
            .margin({ top: 20 })
        } else {
          List() {
            ForEach(this.history, (book: BookModel) => {
              ListItem() {
                BookCardComponent({
                  image: book.image,
                  title: book.title,
                  pageCount: book.pageCount,
                  categories: book.categories,
                  authors: book.authors,
                  readingStatus: ReadingStatusService.getInstance().getStatus(book.title)
                })
                .onClick(() => {
                  this.pathStack.pushPath({
                    name: 'BookDetailPage',
                    param: book
                  })
                })
              }
            }, (item: BookModel) => item.title + item.previewLink)
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
    }
    .title('Recently Viewed')
    .hideBackButton(false)
  }
}
