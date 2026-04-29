import { ArcList, ArcListItem } from '@kit.ArkUI';
import { BookCardComponent } from '../component/BookCardComponent'
import { BookViewModel } from '../viewmodel/BookViewModel';
import BookModel from '../model/BookModel';
import { CategoryPickerDialog } from '../component/CategoryPickerDialog';
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
  private dialogController: CustomDialogController | null = null;

  aboutToAppear() {
    if (this.viewModel.allBooks.length === 0) {
      this.viewModel.fetchBooks(this.getUIContext())
    }
  }

  private openPicker() {
    if (this.viewModel.categories.length === 0) {
      return
    }
    const idx = this.viewModel.categories.indexOf(this.viewModel.selectedCategory)
    const initialIndex = idx >= 0 ? idx : 0
    this.dialogController = new CustomDialogController({
      builder: CategoryPickerDialog({
        categories: this.viewModel.categories,
        initialIndex: initialIndex,
        onConfirm: (category: string) => {
          this.viewModel.selectCategory(category)
        }
      }),
      customStyle: true,
      alignment: DialogAlignment.Center
    })
    this.dialogController.open()
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text('▾')
            .fontSize(12)
            .fontColor('#888888')
            .opacity(0)

          Text(this.viewModel.selectedCategory)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ left: 2, right: 2 })

          Text('▾')
            .fontSize(12)
            .fontColor('#888888')
        }
        .backgroundColor('#2A2A2A')
        .borderRadius(14)
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .margin({ top: 18, bottom: 6 })
        .onClick(() => { this.openPicker() })

        ArcList() {
          ForEach(this.viewModel.filteredBooks, (book: BookModel) => {
            ArcListItem() {
              BookCardComponent({
                image: book.image,
                title: book.title,
                pageCount: book.pageCount,
                categories: book.categories,
                authors: book.authors,
                readingStatus: ReadingStatusService.getInstance().getStatus(book.id)
              })
                .onClick(() => {
                  this.pathStack.pushPath({ name: 'BookDetailPage', param: book })
                })
            }
          }, (item: BookModel) => `${item.title}${item.previewLink}`)
        }
        .width('100%')
        .layoutWeight(1)
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
