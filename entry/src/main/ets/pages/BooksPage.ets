import { BookCardComponent } from '../component/BookCardComponent'
import { BookViewModel } from '../viewmodel/BookViewModel';
import BookModel from '../model/BookModel';
import { FilterComponent } from '../component/FilterComponent';
import { ReadingStatusService } from '../model/ReadingStatusService';

@Builder
export function BooksPageBuilder() {
  BooksPage()
}

@Entry
@Component
struct BooksPage {
  @State viewModel: BookViewModel = BookViewModel.instance;
  @Consume('mainStack') pathStack: NavPathStack;

  aboutToAppear() {
    this.viewModel.fetchBooks(this.getUIContext())
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text('‹')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .width(40).height(40)
            .textAlign(TextAlign.Center)
            .backgroundColor('#444444')
            .borderRadius(20)
            .onClick(() => { this.pathStack.pop() })
        }
        .width('100%')
        .padding({ left: 28, top: 12, bottom: 4 })

        FilterComponent({
          categories: this.viewModel.categories,
          selectedCategory: this.viewModel.selectedCategory,
          onCategorySelected: (category: string) => {
            this.viewModel.selectCategory(category)
          }
        })

        Scroll() {
          Column() {
            ForEach(this.viewModel.filteredBooks, (book: BookModel) => {
              BookCardComponent({
                image: book.image,
                title: book.title,
                pageCount: book.pageCount,
                categories: book.categories,
                authors: book.authors,
                readingStatus: ReadingStatusService.getInstance().getStatus(book.title)
              })
              .margin({ bottom: 6 })
              .onClick(() => {
                this.pathStack.pushPath({ name: 'BookDetailPage', param: book })
              })
            }, (item: BookModel) => item.title + item.previewLink)
          }
          .padding({ left: 12, right: 12, top: 8, bottom: 20 })
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
    .hideTitleBar(true)
    .backgroundColor('#000000')
  }
}
