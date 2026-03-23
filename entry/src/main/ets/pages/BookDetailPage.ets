import { BookDetailCard } from '../component/BookDetailCard';
import BookModel from '../model/BookModel';
import { ReadingStatusService, ReadingStatus } from '../model/ReadingStatusService';
import { FavoritesService } from '../model/FavoritesService';
import { BookHistoryService } from '../model/BookHistoryService';
import { NotesService } from '../model/NotesService';
import { ShareService } from '../model/ShareService';
import { BookViewModel } from '../viewmodel/BookViewModel';

@Builder
export function BookDetailPageBuilder() {
  BookDetailPage()
}

@Entry
@Component
struct BookDetailPage {
  scroller: Scroller = new Scroller()
  @Consume('mainStack') pathStack: NavPathStack
  @State readingStatus: ReadingStatus = ReadingStatus.NONE
  @State isFavorite: boolean = false
  @State note: string = ''
  @State currentBookIndex: number = 0
  @State book: BookModel = {
    title: '',
    pageCount: 0,
    image: '',
    description: '',
    categories: [],
    authors: [],
    publishedDate: '',
    publisher: '',
    previewLink: '',
    language: ''
  }

  aboutToAppear(): void {
    // get the parameters
    const param = this.pathStack.getParamByName('BookDetailPage')[0] as BookModel
    this.book = param
    this.updateState()
    this.currentBookIndex = BookViewModel.instance.filteredBooks.findIndex(b => b.title === this.book.title)
  }

  getStatusIndex(status: ReadingStatus): number {
    const statuses: ReadingStatus[] = [ReadingStatus.NONE, ReadingStatus.TO_READ, ReadingStatus.READING, ReadingStatus.READ];
    const idx = statuses.indexOf(status);
    return idx >= 0 ? idx : 0;
  }

  updateState() {
    this.readingStatus = ReadingStatusService.getInstance().getStatus(this.book.title)
    this.isFavorite = FavoritesService.getInstance().isFavorite(this.book.title)
    this.note = NotesService.getInstance().getNote(this.book.title)
    BookHistoryService.getInstance().addToHistory(this.book)
  }

  build() {
    NavDestination() {
      Swiper() {
        ForEach(BookViewModel.instance.filteredBooks, (book: BookModel) => {
          this.bookDetailView(book)
        }, (item: BookModel) => item.title + item.previewLink)
      }
      .index(this.currentBookIndex)
      .onChange((index: number) => {
        this.book = BookViewModel.instance.filteredBooks[index]
        this.updateState()
      })
      .loop(false)
      .indicator(false)
    }
    .hideBackButton(false)
  }

  @Builder
  bookDetailView(book: BookModel) {
    Column() {
      Row() {
        Button(FavoritesService.getInstance().isFavorite(book.title) ? '❤️' : '🤍')
          .onClick(() => {
            FavoritesService.getInstance().toggleFavorite(book)
            this.isFavorite = FavoritesService.getInstance().isFavorite(book.title)
          })
          .backgroundColor(Color.Transparent)
          .margin({ right: 10 })

        Button('📤 Share')
          .onClick(() => {
            ShareService.getInstance().shareBook(book)
          })
          .backgroundColor(Color.Transparent)
          .margin({ right: 10 })

        Text('Status: ' + ReadingStatusService.getInstance().getStatus(book.title))
          .fontSize(14)
          .margin({ right: 10 })
        Select([{ value: ReadingStatus.NONE }, { value: ReadingStatus.TO_READ }, { value: ReadingStatus.READING }, { value: ReadingStatus.READ }])
          .selected(this.getStatusIndex(ReadingStatusService.getInstance().getStatus(book.title)))
          .onSelect((index: number, value: string) => {
            ReadingStatusService.getInstance().setStatus(book.title, value as ReadingStatus)
            this.readingStatus = value as ReadingStatus
          })
      }
      .padding(10)
      .width('100%')
      .justifyContent(FlexAlign.End)

      BookDetailCard({
        image: book.image,
        title: book.title,
        description: book.description,
        authors: book.authors,
        publisher: book.publisher,
        publishedDate: book.publishedDate,
        pageCount: book.pageCount,
        language: book.language
      })

      if (book.previewLink) {
        Button('Preview Book')
          .onClick(() => {
            console.info('Opening preview link: ' + book.previewLink)
          })
          .margin({ top: 10 })
      }

      Column() {
        Text('Personal Notes')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, bottom: 5 })
        TextArea({ text: NotesService.getInstance().getNote(book.title), placeholder: 'Add your notes here...' })
          .height(100)
          .onChange((value: string) => {
            NotesService.getInstance().setNote(book.title, value)
          })
      }
      .padding(10)
      .width('100%')
    }
  }
}
