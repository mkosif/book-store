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
  @State errorMessage: string = '';

  async search() {
    if (!this.query.trim()) {
      return;
    }
    this.isLoading = true;
    this.hasSearched = true;
    this.errorMessage = '';
    try {
      this.results = await BookService.searchBooks(this.getUIContext(), this.query);
    } catch (e) {
      const error = e as Error;
      this.errorMessage = error.message;
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
            .fontSize(11)
            .fontColor('#FFFFFF')
            .placeholderColor('#A8A8A8')
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => { this.query = value })
            .onSubmit(() => { this.search() })

          Text('🔍')
            .fontSize(14)
            .fontColor('#E8F1FF')
            .width(20)
            .textAlign(TextAlign.Center)
            .onClick(() => { this.search() })
        }
        .width('70%')
        .height(36)
        .alignItems(VerticalAlign.Center)
        .backgroundColor('#242424')
        .border({ width: 1, color: '#5A5A5A' })
        .borderRadius(12)
        .padding({ left: 10, right: 8 })
        .margin({ top: 26, bottom: 8 })

        if (this.isLoading) {
          LoadingProgress()
            .width(36).height(36)
            .color('#4A90E2')
            .margin({ top: 40 })
        } else if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(11)
            .fontColor('#FF6B6B')
            .textAlign(TextAlign.Center)
            .width('72%')
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
              }, (book: BookModel) => book.id || book.previewLink || book.title)
            }
            .padding({ left: 12, right: 12, bottom: 20 })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#000000')
    }
    .hideTitleBar(true)
    .backgroundColor('#000000')
  }
}
