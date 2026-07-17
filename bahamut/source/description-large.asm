namespace render {
namespace large {

seek(textCursor)

//Render one tagged 12x12 field-message glyph for render.large.bpp4().  Keep
//the unrolled copy in expanded ROM because the legacy renderer's $f0 bank is
//already full.  Carry reports clipping so the caller can finish the row.
function bpp4KoGlyph {
  php; rep #$30; phx; phy

  lda.w bpp4.index; tax
  lda.w render.text,x; and #$00ff; sta.w bpp4.character; inx
  lda.w render.text,x; and #$00ff; xba; add.w bpp4.character
  sta.w bpp4.character; inx
  txa; sta.w bpp4.index

  //source <= shifted runtime-text page + compact glyph index * 48
  lda.w bpp4.pixel; and #$0004; beq +; lda.w #$3000; bra ++; +; lda.w #$0000; +
  pha; lda.w bpp4.character; and.w #koFontPage.indexMask
  mul(48); add $01,s; tax; pla

  //Each horizontal tile column occupies 64 bytes in the temporary layout.
  lda.w bpp4.pixel; and #$00f8; asl #3; tay

  lda.w bpp4.pixel; add #$000c; cmp.w bpp4.pixels; bcc +; beq +
  lda.w bpp4.pixels; sta.w bpp4.pixel
  ply; plx; plp; sec; rtl
+;sta.w bpp4.pixel

  macro upper(variable n) {
    lda.l koRuntimeTextFont.normal+$00+n*2,x
    ora.w $6004+n*2,y; sta.w $6004+n*2,y
    lda.l koRuntimeTextFont.normal+$18+n*2,x
    ora.w $6044+n*2,y; sta.w $6044+n*2,y
  }
  macro lower(variable n) {
    lda.l koRuntimeTextFont.normal+$0c+n*2,x
    ora.w $6020+n*2,y; sta.w $6020+n*2,y
    lda.l koRuntimeTextFont.normal+$24+n*2,x
    ora.w $6060+n*2,y; sta.w $6060+n*2,y
  }
  upper(0); upper(1); upper(2); upper(3); upper(4); upper(5)
  lower(0); lower(1); lower(2); lower(3); lower(4); lower(5)

  ply; plx; plp; clc; rtl
}

textCursor = pc()

}
}

namespace menu {
namespace largeText {

seek(textCursor)

//Render one tagged description/runtime/name glyph into the menu OAM buffer.
//is deliberately kept in expanded ROM after the script blob; the normal $f0
//and $f1 code banks are full and only perform a long jump to this routine.
function renderDescriptionKoGlyphLoaded {
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

  macro render(variable font) {
    macro lineL(variable n) {
      variable r = n < 6 ? n * 2 : $01fc + (n - 6) * 2
      lda.l font+$00+n*2,x
      ora.w output+r,y; sta.w output+r,y
    }
    lda ramAddressL; tay
    lineL(0); lineL(1); lineL(2);  lineL(3);  lineL(4);  lineL(5)
    lineL(6); lineL(7); lineL(8);  lineL(9);  lineL(10); lineL(11)

    macro lineR(variable n) {
      variable r = n < 6 ? n * 2 : $01fc + (n - 6) * 2
      lda.l font+$18+n*2,x
      ora.w output+r,y; sta.w output+r,y
    }
    lda ramAddressR; tay
    lineR(0); lineR(1); lineR(2);  lineR(3);  lineR(4);  lineR(5)
    lineR(6); lineR(7); lineR(8);  lineR(9);  lineR(10); lineR(11)
    rtl
  }

  lda character; and.w #koFontPage.descriptionMask
  cmp.w #koFontPage.runtimeText; jeq runtimeText
  cmp.w #koFontPage.techniqueName; jeq technique
  cmp.w #koFontPage.itemName; jeq itemName
  shared:; render(koDescriptionFont.normal)
  runtimeText:; render(koRuntimeTextFont.normal)
  technique:; render(koTechniqueNameFont.normal)
  itemName:; render(koItemNameFont.normal)
}

//The original chapter-name engine derives its DMA/sprite counts from the
//character count in $12 (JP titles are one byte per character, ten max).
//KO rendering advances $12 by three bytes per glyph, which overruns the
//engine's per-character position table and clips longer titles. Recompute
//$12 from the rendered pixel width before resuming the original code
//(every KO title glyph is a fixed 12px cell).
function chapterNameFinish {
  php; rep #$30; pha; phx
  lda pixel
  ldx #$0000
-;cmp #$000c; bcc +
  sub #$000c; inx; bra -
+;txa; sta $12
  plx; pla; plp
  jml $ee55bb
}

textCursor = pc()

}
}

namespace combat {

seek(textCursor)

//The $f0 code bank has no room for another unrolled 12-line font renderer.
//Keep the description renderer in expanded ROM and jump here only when an
//encoded KO glyph carries an item or technique description page tag.
function renderDescriptionKoGlyphLoaded {
  phx; phy

  //Combat descriptions are centered within the detected text-window width.
  //Y already points past the first tagged glyph, so rewind its three encoded
  //bytes while measuring the complete line.  The caller's Y is restored from
  //the stack below; menu descriptions keep their independent layout.
  lda renderLargeText.pixel; bne centered
    dey; dey; dey
    jsl renderLargeText.align.center

    //Descriptions occupy an 18-cell grid.  Exact pixel centering already
    //gives equal margins; for an odd glyph count, shift left by half a cell
    //so the unmatched full cell remains on the right (eg. 13 => 2 / 3).
    //Each tagged glyph is 12px, so bit 2 of the measured width is set only
    //for an odd number of glyphs.
    and #$0004; beq centered
    lda renderLargeText.pixel; sub #$0006; sta renderLargeText.pixel
  centered:

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

  macro render(variable font) {
    macro line(variable n) {
      lda.l font+$00+n*2,x
      ora.w $0000+n*2,y; sta.w $0000+n*2,y
      lda.l font+$18+n*2,x
      ora.w $0020+n*2,y; sta.w $0020+n*2,y
    }
    line(0); line(1); line(2);  line(3);  line(4);  line(5)
    line(6); line(7); line(8);  line(9);  line(10); line(11)
    ply; plx; rtl
  }

  //Technique names need more than the shared description page can hold.
  //Keep their compact index space isolated and choose the font from the page
  //tag before applying the existing normal/yellow combat color.
  lda renderLargeText.character; and.w #koFontPage.descriptionMask
  cmp.w #koFontPage.runtimeText; jeq runtimeText
  cmp.w #koFontPage.techniqueName; jeq technique
  cmp.w #koFontPage.itemName; jeq itemName
  lda renderLargeText.color; jne descriptionYellow
  descriptionNormal:; render(koDescriptionFont.normal)
  descriptionYellow:; render(koDescriptionFont.yellow)

runtimeText:
  lda renderLargeText.color; jne runtimeTextYellow
  runtimeTextNormal:; render(koRuntimeTextFont.normal)
  runtimeTextYellow:; render(koRuntimeTextFont.yellow)

technique:
  lda renderLargeText.color; jne techniqueYellow
  techniqueNormal:; render(koTechniqueNameFont.normal)
  techniqueYellow:; render(koTechniqueNameFont.yellow)

itemName:
  lda renderLargeText.color; jne itemNameYellow
  itemNameNormal:; render(koItemNameFont.normal)
  itemNameYellow:; render(koItemNameFont.yellow)
}

textCursor = pc()

}

namespace field {

seek(textCursor)

//Field range descriptions arrive here after field.renderLargeText has already
//computed the shifted source index in X and the WRAM destination in Y.  Finish
//the existing enter/leave frame in expanded ROM to keep bank $f0 below its
//hard limit.
function renderDescriptionKoGlyphLoaded {
  macro render(variable font) {
    macro line(variable n) {
      lda.l font+$00+n*2,x
      ora.w $0000+n*2,y; sta.w $0000+n*2,y
      lda.l font+$18+n*2,x
      ora.w $0020+n*2,y; sta.w $0020+n*2,y
    }
    line(0); line(1); line(2);  line(3);  line(4);  line(5)
    line(6); line(7); line(8);  line(9);  line(10); line(11)
    leave; rtl
  }

  lda field.renderLargeText.character; and.w #koFontPage.descriptionMask
  cmp.w #koFontPage.runtimeText; jeq runtimeText
  cmp.w #koFontPage.techniqueName; jeq technique
  cmp.w #koFontPage.itemName; jeq itemName
  shared:; render(koDescriptionFont.normal)
  runtimeText:; render(koRuntimeTextFont.normal)
  technique:; render(koTechniqueNameFont.normal)
  itemName:; render(koItemNameFont.normal)
}

textCursor = pc()

}
