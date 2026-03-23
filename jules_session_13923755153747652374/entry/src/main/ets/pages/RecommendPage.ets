import { BookCardComponent } from '../component/BookCardComponent'
import BookModel from '../model/BookModel';
import { RecommendationService } from '../model/RecommendationService';
import { ReadingStatusService } from '../model/ReadingStatusService';
import { ThemeService } from '../model/ThemeService';

@Builder
export function RecommendPageBuilder() {
  RecommendPage()
}

@Entry
@Component
struct RecommendPage {
  @State recommendations: BookModel[] = []
  @Consume('mainStack') pathStack: NavPathStack;

  aboutToAppear() {
    this.recommendations = RecommendationService.getInstance().getRecommendations();
  }

  build() {
    NavDestination() {
      Column() {
        Text('Recommended for You')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeService.getInstance().getTextColor())
          .margin(20)

        List() {
          ForEach(this.recommendations, (book: BookModel) => {
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
      .width('100%')
      .height('100%')
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .title('Recommendations')
    .hideBackButton(false)
  }
}
