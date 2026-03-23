import BookModel from '../model/BookModel';
import { HomeViewModel } from '../viewmodel/HomeViewModel';
import { BooksPageBuilder } from './BooksPage';
import { FavoritesPageBuilder } from './FavoritesPage';
import { StatsPageBuilder } from './StatsPage';
import { ThemeService } from '../model/ThemeService';

@Builder
export function HomePageBuilder() {
  HomePage()
}

@Entry
@Component
struct HomePage {
  @State viewModel: HomeViewModel = HomeViewModel.instance;
  @Consume('mainStack') pathStack: NavPathStack;
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  onPageShow() {
    this.viewModel.fetchBooks(this.getUIContext())
  }

  @Builder
  tabBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === index ? Color.Blue : Color.Gray)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
    }.width('100%')
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          Column() {
            Button($r('app.string.bookofday'))
              .backgroundColor($r('app.color.pink'))
              .margin({ bottom: 10 })
              .onClick(async () => {
                const book = this.viewModel.getBookOfDay();
                if (book) {
                  this.pathStack.pushPath({ name: 'BookOfDayPage', param: book });
                }
              })

            Button('Search')
              .backgroundColor(Color.Blue)
              .margin({ bottom: 10 })
              .onClick(() => {
                this.pathStack.pushPathByName('SearchPage', null)
              })

            Button('History')
              .backgroundColor(Color.Orange)
              .margin({ bottom: 10 })
              .onClick(() => {
                this.pathStack.pushPathByName('BookHistoryPage', null)
              })

            Button('Recommendations')
              .backgroundColor(Color.Pink)
              .margin({ bottom: 10 })
              .onClick(() => {
                this.pathStack.pushPathByName('RecommendPage', null)
              })

            Button('Goals')
              .backgroundColor(Color.Green)
              .margin({ bottom: 10 })
              .onClick(() => {
                this.pathStack.pushPathByName('GoalPage', null)
              })

            Button(this.viewModel.name)
              .backgroundColor($r('app.color.gray'))
              .offset({ x: this.viewModel.offsetX, y: this.viewModel.offsetY })
              .onTouch((event: TouchEvent) => {
                if (event.type === TouchType.Down) {
                  this.viewModel.escape()
                  this.viewModel.name = this.viewModel.getRandomResponse()
                }
              })
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .height('100%')
        }.tabBar(this.tabBuilder('Home', 0))

        TabContent() {
          BooksPageBuilder()
        }.tabBar(this.tabBuilder('Books', 1))

        TabContent() {
          FavoritesPageBuilder()
        }.tabBar(this.tabBuilder('Favorites', 2))

        TabContent() {
          StatsPageBuilder()
        }.tabBar(this.tabBuilder('Stats', 3))
      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .hideBackButton(true)
  }
}
