@CustomDialog
export struct CategoryPickerDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: '' })
  categories: string[] = []
  initialIndex: number = 0
  onConfirm: (category: string) => void = () => {}
  @State tempIndex: number = 0

  aboutToAppear() {
    this.tempIndex = this.initialIndex
  }

  build() {
    Column() {
      Text('Category')
        .fontSize(12)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .margin({ top: 4, bottom: 6 })

      TextPicker({ range: this.categories, selected: this.initialIndex })
        .onChange((_value: string | string[], index: number | number[]) => {
          this.tempIndex = typeof index === 'number' ? index : index[0]
        })
        .selectedTextStyle({ color: '#FFFFFF', font: { size: 12, weight: FontWeight.Medium } })
        .textStyle({ color: '#555555', font: { size: 10 } })
        .canLoop(false)
        .width('100%')
        .height(80)

      Row() {
        Text('Cancel')
          .fontSize(14)
          .fontColor('#ffb52121')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .height(30)
          .onClick(() => { this.controller.close() })

        Divider()
          .vertical(true)
          .strokeWidth(0.5)
          .color('#333333')
          .height(18)

        Text('OK')
          .fontSize(12)
          .fontColor('#4A90E2')
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .height(30)
          .onClick(() => {
            const safeIndex = this.tempIndex >= 0 && this.tempIndex < this.categories.length
              ? this.tempIndex
              : 0
            this.onConfirm(this.categories[safeIndex])
            this.controller.close()
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('80%')
    .backgroundColor('#1C1C1E')
    .borderRadius(12)
    .border({ width: 1, color: '#2C2C2E' })
    .clip(true)
  }
}
