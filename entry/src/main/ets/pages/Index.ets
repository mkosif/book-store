import { curves } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private timerId = 0;
  @State imageTranslateY: number = 18;
  @State textOffsetY: number = 10;
  @State textOpacity: number = 0;
  @Provide('mainStack') pathStack: NavPathStack = new NavPathStack()

  aboutToAppear() {
    setTimeout(() => {
      this.textOffsetY = 0;
      this.textOpacity = 1;
    }, 100);

    setTimeout(() => {
      this.imageTranslateY = 0;
    }, 300);

    this.timerId = setTimeout(() => {
      this.pathStack.pushPath({
        name: 'HomePage'
      });
    }, 3000);
  }

  onDestroy() {
    if (this.timerId) {
      clearTimeout(this.timerId);
    }
  }

  build() {
    Navigation(this.pathStack) {
      Stack() {
        Column() {
          Stack() {
            Circle()
              .width(126)
              .height(126)
              .fill('#14100C')
              .border({ width: 1, color: '#5C3B1A' })

            Column() {
              Row() {
                Column()
                  .width(32)
                  .height(44)
                  .backgroundColor('#F2C98A')
                  .borderRadius({ topLeft: 5, bottomLeft: 5 })

                Column()
                  .width(2)
                  .height(48)
                  .backgroundColor('#6E4319')

                Column()
                  .width(32)
                  .height(44)
                  .backgroundColor('#D99A48')
                  .borderRadius({ topRight: 5, bottomRight: 5 })
              }
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .padding({ top: 7, bottom: 7, left: 8, right: 8 })
              .backgroundColor('#2A1A0D')
              .borderRadius(10)

              Text('BOOK')
                .fontSize(18)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10 })

              Text('STORE')
                .fontSize(12)
                .fontColor('#E0A24D')
                .fontWeight(FontWeight.Medium)
                .letterSpacing(1)
                .margin({ top: 1 })
            }
            .alignItems(HorizontalAlign.Center)
          }
          .width(156)
          .height(156)
          .translate({ y: this.imageTranslateY })
          .opacity(this.textOpacity)
          .animation({
            curve: curves.initCurve(),
            iterations: 1,
            duration: 900,
            playMode: PlayMode.Normal
          })

          Text($r('app.string.splash_text'))
            .fontColor('#D6D6D6')
            .fontSize(10)
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 12 })
            .translate({ y: this.textOffsetY })
            .opacity(this.textOpacity)
            .animation({
              curve: curves.initCurve(),
              iterations: 1,
              duration: 800,
              playMode: PlayMode.Normal
            })

        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .backgroundColor('#050505')
        .translate({ y: -6 })
        .animation({
          curve: curves.initCurve(),
          iterations: 1,
          duration: 800,
          playMode: PlayMode.Normal
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#050505')
    }
    .hideTitleBar(true)
  }
}
