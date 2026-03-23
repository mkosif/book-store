import { BookCardComponent } from '../component/BookCardComponent'
import { BookViewModel } from '../viewmodel/BookViewModel';
import BookModel from '../model/BookModel';
import { FilterComponent } from '../component/FilterComponent';
import { ReadingStatusService } from '../model/ReadingStatusService';
import { ThemeService, ThemeMode } from '../model/ThemeService';

@Builder
export function BooksPageBuilder() {
  BooksPage()
}

@Entry
@Component
struct BooksPage {
  scroller: Scroller = new Scroller()
  @State viewModel: BookViewModel = BookViewModel.instance;
  @Consume('mainStack') pathStack: NavPathStack;
  @State isGridView: boolean = false
  @State themeMode: ThemeMode = ThemeService.getInstance().getMode()

  // get  books when open the page
  aboutToAppear() {
    this.viewModel.fetchBooks(this.getUIContext())
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button(this.themeMode === ThemeMode.LIGHT ? '🌙' : '☀️')
            .onClick(() => {
              const newMode = this.themeMode === ThemeMode.LIGHT ? ThemeMode.DARK : ThemeMode.LIGHT
              ThemeService.getInstance().setMode(newMode)
              this.themeMode = newMode
            })
            .backgroundColor(Color.Transparent)

          Blank()

          Button(this.isGridView ? 'List View' : 'Grid View')
            .onClick(() => {
              this.isGridView = !this.isGridView
            })
            .fontSize(12)
        }
        .width('100%')
        .padding({ left: 10, right: 10 })

        FilterComponent({
          categories: this.viewModel.categories,
          selectedCategory: this.viewModel.selectedCategory,
          onCategorySelected: (category: string) => {
            this.viewModel.selectCategory(category)
          }
        })

        Scroll(this.scroller) {
          if (this.isGridView) {
            Grid() {
              ForEach(this.viewModel.filteredBooks, (book: BookModel) => {
                GridItem() {
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
            .columnsTemplate('1fr 1fr')
            .columnsGap(10)
            .rowsGap(10)
            .padding(10)
          } else {
            Column() {
              ForEach(this.viewModel.filteredBooks, (book: BookModel, index: number) => {
                BookCardComponent({
                  image: book.image,
                  title: book.title,
                  pageCount: book.pageCount,
                  categories: book.categories,
                  authors: book.authors,
                  readingStatus: ReadingStatusService.getInstance().getStatus(book.title)
                }).padding({ bottom: 4 })
                  .onClick(() => {
                    this.pathStack.pushPath({
                      name: 'BookDetailPage',
                      param: book
                    })
                  })
                Divider().height(2).color(0xCCCCCC).padding({ left: 40, right: 40, bottom: 10 });
              }, (item: BookModel) => item.title + item.previewLink)
            }.padding({ bottom: 15, top: 15 })
          }
        }.width('100%').layoutWeight(1)
      }
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .hideBackButton(false)
  }
}
