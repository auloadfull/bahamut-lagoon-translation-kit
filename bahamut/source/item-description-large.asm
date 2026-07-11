namespace menu {
namespace largeText {

seek(textCursor)

//Render one tagged item-description glyph into the menu OAM text buffer.  This
//is deliberately kept in expanded ROM after the script blob; the normal $f0
//and $f1 code banks are full and only perform a long jump to this routine.
function renderItemDescriptionKoGlyphLoaded {
  //calculate first and second RAM tile write positions
  lda pixel; and #$00f8; asl #2; cmp #$0200; bcc +
  add #$0200; +; sta ramAddressL
  lda pixel; add #$0008; and #$00f8; asl #2; cmp #$0200; bcc +
  add #$0200; +; sta ramAddressR

  //source <= shifted page + compact glyph index * 48
  lda pixel; and #$0004; beq +; lda.w #$3000; bra ++; +; lda.w #$0000; +
  pha; lda character; and.w #koFontPage.indexMask
  mul(48); add $01,s; tax; pla

  lda pixel; add #$000c; cmp pixels; bcc +; beq +
  lda pixels; sta pixel; rtl
+;sta pixel

  macro lineL(variable n) {
    variable r = n < 6 ? n * 2 : $01fc + (n - 6) * 2
    lda.l koItemDescriptionFont.normal+$00+n*2,x
    ora.w output+r,y; sta.w output+r,y
  }
  lda ramAddressL; tay
  lineL(0); lineL(1); lineL(2);  lineL(3);  lineL(4);  lineL(5)
  lineL(6); lineL(7); lineL(8);  lineL(9);  lineL(10); lineL(11)

  macro lineR(variable n) {
    variable r = n < 6 ? n * 2 : $01fc + (n - 6) * 2
    lda.l koItemDescriptionFont.normal+$18+n*2,x
    ora.w output+r,y; sta.w output+r,y
  }
  lda ramAddressR; tay
  lineR(0); lineR(1); lineR(2);  lineR(3);  lineR(4);  lineR(5)
  lineR(6); lineR(7); lineR(8);  lineR(9);  lineR(10); lineR(11)
  rtl
}

textCursor = pc()

}
}

namespace combat {

seek(textCursor)

//The $f0 code bank has no room for another unrolled 12-line font renderer.
//Keep the item-description-only renderer in expanded ROM and jump here only
//when the encoded KO glyph carries koFontPage.itemDescription.
function renderItemDescriptionKoGlyphLoaded {
  phx; phy

  //The original combat item-description row begins three 12px cells in from
  //the left.  Apply it only once, before rendering the first tagged glyph;
  //the party-menu path intentionally keeps its existing position.
  lda renderLargeText.pixel; bne +
    lda #$0024; sta renderLargeText.pixel
  +

  //source <= shifted page + compact glyph index * 48
  lda renderLargeText.pixel; and #$0004; beq +; lda.w #$3000; bra ++; +; lda.w #$0000; +
  pha; lda renderLargeText.character; and.w #koFontPage.indexMask
  mul(48); add $01,s; tax; pla

  //target <= combat large-text WRAM buffer + pixel / 8 * 32
  lda renderLargeText.pixel; and #$00f8; asl #2
  add.w #renderLargeText.wramBuffer; tay

  lda renderLargeText.pixel; add #$000c
  cmp renderLargeText.pixels; bcc +; beq +
  lda renderLargeText.pixels; sta renderLargeText.pixel
  ply; plx; rtl
+;sta renderLargeText.pixel

  macro line(variable n) {
    lda.l koItemDescriptionFont.normal+$00+n*2,x
    ora.w $0000+n*2,y; sta.w $0000+n*2,y
    lda.l koItemDescriptionFont.normal+$18+n*2,x
    ora.w $0020+n*2,y; sta.w $0020+n*2,y
  }
  line(0); line(1); line(2);  line(3);  line(4);  line(5)
  line(6); line(7); line(8);  line(9);  line(10); line(11)
  ply; plx; rtl
}

textCursor = pc()

}
