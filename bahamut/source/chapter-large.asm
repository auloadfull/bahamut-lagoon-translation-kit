namespace chapter {

seek(codeCursor)

namespace renderLargeText {
  enqueue pc
  seek($da3b22); jsl main
  dequeue pc

  constant wramBuffer  = $7ee2a6  //location where rendered tiledata is written to
  constant eventNumber =   $0310  //the current event number that is running
  constant tileCount   =   $095f  //the number of tiles to be copied to VRAM
  constant lineNumber  =   $0960  //usually 0-2, but can be 0-3
  constant buffer      =     $76  //the text string is rendered from [$76],y

  variable(1024, text)    //memory to decode dialogue text to
  variable(2, character)  //the current decoded character being rendered
  variable(2, pixel)      //the current pixel offset being rendered to
  variable(2, pixels)     //the maximum number of pixels allowed on one line of text
  variable(2, style)      //the current style being used ($00 = normal, $60 = italic)
  variable(2, color)      //the current color being used ($00 = normal, $01 = yellow)

  //this routine renders one line of dialogue text per invocation
  //------
  //da3b22  lda [$76],y  ;load the next character
  //da3b24  cmp #$f0     ;test if it's a control code
  //------
  //Y => current string read position
  function main {
    //Opening credits restored to the JP original. The common $da3b22 hook stays
    //(every Korean chapter needs it), but event $fa now passes through to the JP
    //native renderer instead of Near's pre-rendered path: reproduce the original
    //LDA [$76],Y / CMP #$F0 (the four bytes this hook replaced) and rtl, so the
    //BCS at $da3b26 sees the correct A and C/Z/N. The insert(fa) override is also
    //removed so the JP $fa event data survives. openingCredits.main stays defined
    //but is no longer reached.
    lda.w eventNumber; cmp #$fa; bne +        //$fa is the opening credits event#
    lda $78; cmp.b #render.text >> 16; beq +  //ensure this isn't the debugger event# string
    lda [buffer],y; cmp.b #$f0; rtl; +

    phb; php; rep #$30; phx
    ldb #$7e

    //detect the first character in a textbox rendered to initialize state
    cpy #$0000; bne +; jsl initialize; +

    loop: {
      lda [buffer],y; and #$00ff
      cmp.w #command.base;        bcs +; jsl renderCharacter; iny; bra loop; +
      cmp.w #command.pause;       bcc +; bra return; +
      cmp.w #command.styleNormal; bne +; lda.w #$00; sta style; iny; bra loop; +
      cmp.w #command.styleItalic; bne +; lda.w #$60; sta style; iny; bra loop; +
      cmp.w #command.colorNormal; bne +; lda.w #$00; sta color; iny; bra loop; +
      cmp.w #command.colorYellow; bne +; lda.w #$01; sta color; iny; bra loop; +
      cmp.w #command.alignLeft;   bne +; jsl align.left;   bra loop; +
      cmp.w #command.alignCenter; bne +; jsl align.center; bra loop; +
      cmp.w #command.alignRight;  bne +; jsl align.right;  bra loop; +
      cmp.w #command.alignSkip;   bne +; jsl align.skip;   bra loop; +
      cmp.w #command.reserved0;   bne +; jsl renderKoGlyph; jmp loop; +
      iny; jmp loop
    }

  return:
    //store the number of tiles rendered so the game will transfer them all to VRAM
    pha; lda pixel; add #$0007; div(8)
    sep #$20; sta.w tileCount; rep #$20
    pla; cmp.w #command.lineFeed; bne +; pha; lda #$0000; sta character; sta pixel; pla; +
    plx; plp; plb
    sec; rtl
  }

  function initialize {
    lda #$0000; sta character; sta pixel; sta style; sta color
    lda.w #240; sta pixels

    //decode text for easier processing
    ldx #$0000
    loop: {
      lda [buffer],y; iny; and #$00ff
      cmp.w #command.reserved0; bne +; jsl koGlyph;  bra loop; +
      cmp.w #command.name;     bne +; jsl name;     bra loop; +
      cmp.w #command.redirect; bne +; jsl redirect; bra loop; +
      sta text,x; inx
      cmp.w #command.wait;     beq +
      cmp.w #command.terminal; beq +
      bra loop; +
    }

    //redirect text to decoded copy
    lda.w #text >> 0; sta buffer+0
    lda.w #text >> 8; sta buffer+1
    ldy #$0000; rtl
  }

  function name {
    lda [buffer],y; iny; and #$00ff
    jsl koName.appendChapterLargeNameAlias
    bcs checkPossessive
    append.name(text)

    //determine if the name is used as a singular possessive
  checkPossessive:
    lda [buffer],y; and #$00ff; cmp.w #'\''; beq +; rtl; +; iny
    append.byte(text, '\'')
    lda [buffer],y; and #$00ff; cmp.w #'s';  beq +; rtl; +; iny

    //omit trailing s if the name ends with an s already
    lda text-2,x; and #$00ff; cmp.w #'s'; beq +
    append.byte(text, 's')
  +;rtl
  }

  function koGlyph {
    sta text,x; inx
    lda [buffer],y; iny; and #$00ff; sta text,x; inx
    lda [buffer],y; iny; and #$00ff; sta text,x; inx
    rtl
  }

  function redirect {
    lda [buffer],y; iny; sta redirection.address+0
    lda [buffer],y; iny; sta redirection.address+1
    lda [buffer],y; iny; sta redirection.address+2
    redirection.enable()
    lda redirection.address+0; sta buffer+0
    lda redirection.address+1; sta buffer+1
    redirection.disable()
    ldy #$0000; rtl
  }

  namespace align {
    function left {
      lda.w #0; sta pixel; rtl
    }

    function center {
      iny; tya; add buffer+0; sta render.large.width.address+0
      lda.w #0; adc buffer+2; sta render.large.width.address+2
      lda style; sta render.large.width.style; jsl render.large.width
      cmp pixels; bcc +; beq +; lda.w #0; sta pixel; rtl; +
      pha; lda pixels; inc; sub $01,s; lsr; sta pixel; pla; rtl
    }

    function right {
      iny; tya; add buffer+0; sta render.large.width.address+0
      lda.w #0; adc buffer+2; sta render.large.width.address+2
      lda style; sta render.large.width.style; jsl render.large.width
      cmp pixels; bcc +; beq +; lda.w #0; sta pixel; rtl; +
      pha; lda pixels; sub $01,s; sta pixel; pla; rtl
    }

    function skip {
      iny; lda [buffer],y; iny; and #$00ff
      add pixel; sta pixel; rtl
    }
  }

  //A => encoded character
  function renderCharacter {
    phy; character.decode(); add style; pha

    //perform font kerning
    lda character; mul(180); add $01,s; tax
    lda largeFont.kernings,x; and #$00ff; pha
    lda pixel; sub $01,s; sta pixel; pla; pla
    sta character

    //select the WRAM write location for the current character:
    //Y <= lineNumber * 1024 + tileNumber * 32
    lda.w lineNumber; mul(1024); pha
    lda pixel; and #$00f8; asl #2; add $01,s; tay; pla

    //select the font read location for the current character:
    //X <= (pixel & 7) * 8192 + character * 44
    lda pixel; and #$0007; mul(8192); pha
    lda character; mul(44); add $01,s; tax; pla

    //add the width of the current character to the pixel counter
    phx; lda character; tax
    lda largeFont.widths,x; and #$00ff
    plx; add pixel; cmp pixels; bcc +; beq +
    lda pixels; sta pixel; ply; rtl
  +;sta pixel

    //draw all 11 lines of the current character
    lda color; jne yellow

    macro render(variable font) {
      macro line(variable n) {
        lda.l font+$00+n*2,x; ora.w wramBuffer+$00+n*2,y; sta.w wramBuffer+$00+n*2,y
        lda.l font+$16+n*2,x; ora.w wramBuffer+$20+n*2,y; sta.w wramBuffer+$20+n*2,y
      }
      line(0); line(1); line(2); line(3); line(4)
      line(5); line(6); line(7); line(8); line(9); line(10)
      ply; rtl
    }

    normal:; render(largeFont.normal)
    yellow:; render(largeFont.yellow)
  }

  //$fa + u16 => compact KO 12x12 glyph index
  function renderKoGlyph {
    iny; lda [buffer],y; and #$00ff; sta character
    iny; lda [buffer],y; and #$00ff; xba; add character; sta character
    iny; phy

    //select the WRAM write location for the current character:
    //Y <= lineNumber * 1024 + tileNumber * 32
    lda.w lineNumber; mul(1024); pha
    lda pixel; and #$00f8; asl #2; add $01,s; tay; pla

    //select the font read location inside the selected sub-blob:
    //X <= (pixel & 4 ? shifted-page : base-page) + (character & $ff) * 48
    lda pixel; and #$0004; beq +; lda.w #$3000; bra ++; +; lda.w #$0000; +
    pha; lda character; and #$00ff; mul(48); add $01,s; tax; pla

    lda pixel; add #$000c; cmp pixels; bcc +; beq +
    lda pixels; sta pixel; ply; rtl
  +;sta pixel

    //sub-blob dispatch and the unrolled copies live in expanded ROM;
    //bank $f0 has no room for eight render instances.
    jml renderKoGlyphTail
  }
}

codeCursor = pc()

seek(textCursor)

namespace renderLargeText {
  //Copy one 12x12 KO glyph from the sub-blob selected by compact index bits
  //8-9. Entered via jml from renderKoGlyph with X = in-blob offset and
  //Y = WRAM tile offset already computed; rtl returns to renderKoGlyph's
  //original caller.
  function renderKoGlyphTail {
    macro render(variable font) {
      macro line(variable n) {
        lda.l font+$00+n*2,x; ora.w wramBuffer+$00+n*2,y; sta.w wramBuffer+$00+n*2,y
        lda.l font+$18+n*2,x; ora.w wramBuffer+$20+n*2,y; sta.w wramBuffer+$20+n*2,y
      }
      line(0); line(1); line(2);  line(3);  line(4);  line(5)
      line(6); line(7); line(8);  line(9);  line(10); line(11)
      ply; rtl
    }

    lda character; and #$0300
    cmp #$0100; jeq sub1
    cmp #$0200; jeq sub2
    cmp #$0300; jeq sub3
    sub0:; lda color; jne yellow0
      normal0:; render(koLargeFont.sub0.normal)
      yellow0:; render(koLargeFont.sub0.yellow)
    sub1:; lda color; jne yellow1
      normal1:; render(koLargeFont.sub1.normal)
      yellow1:; render(koLargeFont.sub1.yellow)
    sub2:; lda color; jne yellow2
      normal2:; render(koLargeFont.sub2.normal)
      yellow2:; render(koLargeFont.sub2.yellow)
    sub3:; lda color; jne yellow3
      normal3:; render(koLargeFont.sub3.normal)
      yellow3:; render(koLargeFont.sub3.yellow)
  }
}

textCursor = pc()

}
