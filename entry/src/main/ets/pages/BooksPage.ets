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
    if (this.viewModel.allBooks.length === 0) {
      this.viewModel.fetchBooks(this.getUIContext())
    }
  }

  build() {
    NavDestination() {
      Column() {
        Blank().height(10)

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
                readingStatus: ReadingStatusService.getInstance().getStatus(book.id)
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
