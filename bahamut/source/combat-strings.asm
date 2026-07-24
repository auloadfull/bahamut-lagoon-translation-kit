namespace combat {

seek(codeCursor)

namespace defeats {
  enqueue pc
  seek($c1a68a); jsl hook
  dequeue pc

  //------
  //c1a67f  lda [$78],y
  //c1a681  clc
  //c1a682  adc $78
  //c1a684  sta $5e
  //c1a686  sep #$20
  //c1a688  lda $7a
  //c1a68a  adc #$00
  //c1a68c  sta $60
  //------
  function hook {
    adc #$00; sta $60
    enter
    lda $60; and #$00ff; cmp #$00dd; bne +; lda $5e; jsl hookDefeats; +
    lda $60; and #$00ff; cmp #$00de; bne +; lda $5e; jsl hookCombat;  +
    leave; rtl
  }

  function hookDefeats {
    macro hook(define address, variable index) {
      cmp.w #${address}; bne +; pha
      lda.l  lists.defeats.text+index*2
      add.w #lists.defeats.text >>  0; sta $5e; sep #$20
      lda.b #lists.defeats.text >> 16; sta $60; rep #$20
      pla; +
    }
    hook(dd8894, 0)
    hook(dd88b7, 1)
    hook(dd88ed, 2)
    hook(dd8923, 3)
    hook(dd8962, 4)
    hook(dd8980, 5)
    hook(dd89ab, 6)
    hook(dd89f1, 7)
    hook(dd8a28, 8)
    hook(dd8a5c, 9)
    hook(dd8a9c,10)
    hook(dd8ad6,11)
    hook(dd8b06,12)
    hook(dd8b42,13)
    hook(dd8b7c,14)
    hook(dd8bbb,15)
    hook(dd8bf7,16)
    hook(dd8c2a,17)
    hook(dd8c62,18)
    hook(dd8c9f,19)
    hook(dd8cde,20)
    hook(dd8d1a,21)
    hook(dd8d55,22)
    hook(dd8d8d,23)
    hook(dd8dc9,24)
    hook(dd8dfb,25)
    hook(dd8e26,26)
    hook(dd8e57,27)
    hook(dd8e69,28)
    hook(dd8e70,29)
    hook(dd8e93,30)
    hook(dd8ec5,31)
    hook(dd8e8e,32)
    rtl
  }

  function hookCombat {
    macro hook(define address, variable index) {
      cmp.w #${address}; bne +; pha
      lda.l  lists.combat.text+index*2
      add.w #lists.combat.text >>  0; sta $5e; sep #$20
      lda.b #lists.combat.text >> 16; sta $60; rep #$20
      pla; +
    }
    hook(de1d7b, 0)
    hook(de1d83, 1)
    hook(de1d97, 2)
    hook(de1da0, 3)
    hook(de1da9, 4)
    rtl
  }
}

namespace actions {
  enqueue pc
  seek($c154c5); jsl hook
  dequeue pc

  //originally this routine generated a string at $7ea000 and set [$5e] to point at it.
  //the string was in the form: "{dragon}{suffix}"
  //the suffixes were hard-coded, likely from macros in the original source code.
  //instead of hooking each string one by one, the strings are detected and redirected here.
  //------
  //c154cc  dec $5e  ;the pointer to the string gets decremented after generating.
  //c154ce  dec $5e  ;because of this, two inc $5e statements are needed inside this hook.
  //------
  //A => dragon name
  //$28 => string suffix
  function hook {
    enter

    ldx #$0000
    append.alignCenter()
    //KO: a default dragon name is stored as English base56, so append.name draws
    //it as "Ice Dragon". Try the Korean display alias first (carry set = it wrote
    //the name); fall back to the base56 name for player-renamed dragons. PLA does
    //not touch carry, so A is restored for that fallback. Same idiom as
    //combat-large.asm's name renderer.
    pha
    jsl koName.appendRenderTextLargeNameAlias
    pla
    bcc noNameAlias
    //The alias writes its own $ff terminal and steps X past it, which is right
    //when the name is the whole string (combat-large). Here an action suffix
    //follows, so back up onto the terminal - append.* expects X to point at it
    //so the next append overwrites it. Without this the suffix lands after the
    //terminator and the renderer stops at the name.
    dex
    //Topic particle (JP は). Only a default name reaches here, so the batchim is
    //known from the name index: 아이스드래곤(3) and 몰텐(5) end in a consonant and
    //take 은, the other eight take 는. A renamed dragon takes the base56 path
    //below and gets no particle - its batchim is not knowable at this point.
    //Compare the way the alias itself does: it masks with #$00ff internally, so
    //the caller's high byte is not guaranteed clear. Without this mask the
    //compares never match and every name falls through to 는.
    and #$00ff
    cmp.w #$0003; beq nameParticleEun
    cmp.w #$0005; beq nameParticleEun
    append.koGlyph($001e)  //는
    bra nameDone
  nameParticleEun:
    append.koGlyph($001b)  //은
    bra nameDone
  noNameAlias:
    append.name()
  nameDone:

    ldy $28; lda $2a; and #$00ff
    cmp #$00c1; jne redirect
    cpy #$db4f; bne +; lda.w #field.message.dragonFeignsIgnorance; append.stringIndexed(lists.fieldMessages.text); jmp redirect; +  //"はしらんぷり" -> " 딴청을 부린다."
    cpy #$db56; bne +; lda.w #field.message.dragonLooksAway;       append.stringIndexed(lists.fieldMessages.text); jmp redirect; +  //"はよそみしている" -> " 한눈을 팔고 있다."
    cpy #$db5f; bne +; lda.w #field.message.dragonWorried;         append.stringIndexed(lists.fieldMessages.text); jmp redirect; +  //"はこちらをきにしてる" -> " 이쪽을 신경 쓴다."
    cpy #$db6a; bne +; lda.w #field.message.dragonCheers;          append.stringIndexed(lists.fieldMessages.text); jmp redirect; +  //"はおうえんしている" -> " 응원하고 있다."
    cpy #$db74; bne +; lda.w #field.message.dragonPassedBy;        append.stringIndexed(lists.fieldMessages.text); jmp redirect; +  //"はとおりすぎた" -> " 지나쳐 갔다."

  redirect:
    lda.w #render.text >> 0; sta $5e
    lda.w #render.text >> 8; sta $5f
    inc $5e; inc $5e

    leave; rtl
  }
}

namespace unusedStrings {
  enqueue pc
  //it hasn't been confirmed if these strings are reachable or not, but it seems doubtful
  seek($c1db03); db "Get EXP",$ff;    assert(pc() == $c1db0b)  //"ＧＥＴ　ＥＸＰ"
  seek($c1db0b); db "Get Item",$ff;   assert(pc() == $c1db14)  //"ＧＥＴ　ＩＴＥＭ"
  seek($c1db14); db "Get Piro",$ff;   assert(pc() == $c1db1d)  //"ＧＥＴ　ＧＯＬＤ"
  seek($c1db44); db "Underlevel",$ff; assert(pc() == $c1db4f)  //"「レベルがたらんぞ」"
  seek($c1db86); db "TIM",$ff,$ff;    assert(pc() == $c1db8b)  //"うにうに"
  dequeue pc
}

codeCursor = pc()

}
