import { BookCardComponent } from '../component/BookCardComponent';
import BookModel from '../model/BookModel';
import BookService from '../model/BookService';

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
      this.results = [];
    }
    this.isLoading = false;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          TextInput({ placeholder: 'Search...', text: this.query })
            .layoutWeight(1)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .placeholderColor('#555555')
            .backgroundColor('#1A1A1A')
            .borderRadius(10)
            .onChange((value: string) => { this.query = value })
            .onSubmit(() => { this.search() })

          Text('🔍')
            .fontSize(18)
            .padding({ left: 8 })
            .onClick(() => { this.search() })
        }
        .padding({ left: 30, right: 30, top: 16, bottom: 8 })
        .width('100%')

        if (this.isLoading) {
          LoadingProgress()
            .width(36).height(36)
            .color('#4A90E2')
            .margin({ top: 40 })
        } else if (this.hasSearched && this.results.length === 0) {
          Text('No results')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 40 })
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
                .margin({ bottom: 6 })
                .onClick(() => {
                  this.pathStack.pushPath({ name: 'BookDetailPage', param: book })
                })
              }, (book: BookModel) => `${book.title}${book.previewLink}`)
            }
            .padding({ left: 12, right: 12, bottom: 20 })
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
