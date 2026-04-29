import BookModel from '../model/BookModel';
import { HomeViewModel } from '../viewmodel/HomeViewModel';
import { BookViewModel } from '../viewmodel/BookViewModel';

@Builder
export function HomePageBuilder() {
  HomePage()
}

@Entry
@Component
struct HomePage {
  @State viewModel: HomeViewModel = HomeViewModel.instance;
  @State bookViewModel: BookViewModel = BookViewModel.instance;
  @Consume('mainStack') pathStack: NavPathStack;
  @State isLoadingBookOfDay: boolean = false;

  onPageShow() {
    this.viewModel.fetchBooks(this.getUIContext())
  }

  openBookOfDay() {
    const book = this.viewModel.getBookOfDay();
    if (book) {
      this.pathStack.pushPath({ name: 'BookOfDayPage', param: book });
      return;
    }
    this.isLoadingBookOfDay = true;
    this.viewModel.fetchBooks(this.getUIContext()).then(() => {
      this.isLoadingBookOfDay = false;
      const loaded = this.viewModel.getBookOfDay();
      if (loaded) {
        this.pathStack.pushPath({ name: 'BookOfDayPage', param: loaded });
      } else if (this.bookViewModel.lastError) {
        this.getUIContext().getPromptAction().showToast({
          message: this.bookViewModel.lastError,
          duration: 3000
        });
      }
    });
  }

  @Builder
  navCard(icon: string, label: string, action: () => void) {
    Column() {
      Text(icon).fontSize(24)
      Text(label)
        .fontSize(10)
        .fontColor('#CCCCCC')
        .margin({ top: 4 })
        .textAlign(TextAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height(80)
    .borderRadius(18)
    .backgroundColor('#1C1C1C')
    .onClick(action)
  }

  build() {
    NavDestination() {
      Column() {
        Grid() {
          GridItem() {
            Column() {
              if (this.isLoadingBookOfDay) {
                LoadingProgress().width(28).height(28).color('#CCCCCC')
              } else {
                Text('📅').fontSize(24)
                Text('Book of Day')
                  .fontSize(10)
                  .fontColor('#CCCCCC')
                  .margin({ top: 4 })
                  .textAlign(TextAlign.Center)
              }
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .width('100%')
            .height(80)
            .borderRadius(18)
            .backgroundColor('#1C1C1C')
            .onClick(() => { this.openBookOfDay() })
          }
          GridItem() {
            this.navCard('📚', 'Books', () => {
              this.pathStack.pushPathByName('BooksPage', null)
            })
          }
          GridItem() {
            this.navCard('🔍', 'Search', () => {
              this.pathStack.pushPathByName('SearchPage', null)
            })
          }
          GridItem() {
            this.navCard('⭐', 'Favorites', () => {
              this.pathStack.pushPathByName('FavoritesPage', null)
            })
          }
          GridItem() {
            this.navCard('🕐', 'History', () => {
              this.pathStack.pushPathByName('BookHistoryPage', null)
            })
          }
          GridItem() {
            this.navCard('📊', 'Stats', () => {
              this.pathStack.pushPathByName('StatsPage', null)
            })
          }
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .width('72%')
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 24, bottom: 24 })
      .backgroundColor('#000000')
    }
    .backgroundColor('#000000')
    .hideBackButton(true)
  }
}
