import { BookCardComponent } from '../component/BookCardComponent';
import BookModel from '../model/BookModel';
import BookService from '../model/BookService';
import { ThemeService } from '../model/ThemeService';

@Builder
export function SearchPageBuilder() {
  SearchPage()
}

@Entry
@Component
struct SearchPage {
  @Consume('mainStack') pathStack: NavPathStack;
  @State query: string = '';
  @State results: BookModel[] = [];
  @State isLoading: boolean = false;
  @State hasSearched: boolean = false;

  async search() {
    if (!this.query.trim()) return;
    this.isLoading = true;
    this.hasSearched = true;
    try {
      this.results = await BookService.searchBooks(this.getUIContext(), this.query);
    } catch (e) {
      console.error('SearchPage: search failed:', e);
      this.results = [];
    }
    this.isLoading = false;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          TextInput({ placeholder: 'Search books...', text: this.query })
            .layoutWeight(1)
            .fontSize(12)
            .onChange((value: string) => {
              this.query = value;
            })
            .onSubmit(() => {
              this.search();
            })
          Button('Go')
            .onClick(() => { this.search(); })
            .fontSize(12)
            .margin({ left: 5 })
        }
        .padding({ left: 10, right: 10, top: 10, bottom: 5 })
        .width('100%')

        if (this.isLoading) {
          LoadingProgress()
            .height(40)
            .width(40)
            .margin({ top: 30 })
        } else if (this.hasSearched && this.results.length === 0) {
          Text('No results found for "' + this.query + '"')
            .fontSize(12)
            .fontColor(Color.Gray)
            .padding(20)
        } else {
          Scroll() {
            Column() {
              ForEach(this.results, (book: BookModel) => {
                BookCardComponent({
                  image: book.image,
                  title: book.title,
                  pageCount: book.pageCount,
                  categories: book.categories,
                  authors: book.authors
                })
                .onClick(() => {
                  this.pathStack.pushPath({ name: 'BookDetailPage', param: book });
                })
              }, (book: BookModel) => book.title + book.previewLink)
            }.padding({ bottom: 15, top: 5 })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .title('Search Books')
    .hideBackButton(false)
  }
}
