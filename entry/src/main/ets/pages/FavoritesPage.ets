import { BookCardComponent } from '../component/BookCardComponent';
import BookModel from '../model/BookModel';
import { FavoritesService } from '../model/FavoritesService';

@Builder
export function FavoritesPageBuilder() {
  FavoritesPage()
}

@Entry
@Component
struct FavoritesPage {
  @Consume('mainStack') pathStack: NavPathStack;
  @State favorites: BookModel[] = [];

  aboutToAppear() {
    this.favorites = FavoritesService.getInstance().getFavorites();
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

        if (this.favorites.length === 0) {
          Column() {
            Text('⭐')
              .fontSize(32)
              .margin({ bottom: 12 })
            Text('No favorites yet')
              .fontSize(12)
              .fontColor('#666666')
            Text('Tap ❤️ on a book')
              .fontSize(10)
              .fontColor('#444444')
              .margin({ top: 4 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          Scroll() {
            Column() {
              ForEach(this.favorites, (book: BookModel) => {
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
              }, (book: BookModel) => book.title + book.previewLink)
            }
            .padding({ left: 12, right: 12, top: 8, bottom: 20 })
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
