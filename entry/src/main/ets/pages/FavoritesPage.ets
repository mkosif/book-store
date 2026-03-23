import { BookCardComponent } from '../component/BookCardComponent';
import BookModel from '../model/BookModel';
import { FavoritesService } from '../model/FavoritesService';
import { ThemeService } from '../model/ThemeService';

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
        Text('Favorites')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeService.getInstance().getTextColor())
          .padding({ top: 10, bottom: 10 })

        if (this.favorites.length === 0) {
          Column() {
            Text('No favorites yet.')
              .fontSize(13)
              .fontColor(Color.Gray)
            Text('Tap ❤️ on any book to save it.')
              .fontSize(11)
              .fontColor(Color.Gray)
              .margin({ top: 5 })
          }.margin({ top: 30 })
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
                .onClick(() => {
                  this.pathStack.pushPath({ name: 'BookDetailPage', param: book });
                })
              }, (book: BookModel) => book.title + book.previewLink)
            }.padding({ bottom: 15 })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .title('Favorites')
    .hideBackButton(false)
  }
}
