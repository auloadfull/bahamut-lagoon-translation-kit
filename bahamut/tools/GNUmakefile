build := optimized
flags += -I../.. -Wno-narrowing

nall.path := ../../nall
include $(nall.path)/GNUmakefile

hiro.path := ../../hiro
include $(hiro.path)/GNUmakefile

define linkWithNall
  @$(compiler) -o out/$1 obj/$1.o $(options)
endef

define linkWithHiro
  @$(compiler) -o out/$1 $(hiro.objects) obj/$1.o $(hiro.options) $(options)
endef

cli := base56 checksum compressor decompressor
cli += font-encoder font-extractor font-kerner
cli += list-encoder list-extractor
cli += script-encoder script-extractor
cli += string-scanner

editors := list-editor script-editor

objects := $(cli:%=obj/%.o) $(editors:%=obj/%.o)

all: $(hiro.objects) $(objects)
	$(MAKE) cli
	$(call linkWithHiro,list-editor)
	$(call linkWithHiro,script-editor)

cli: $(cli:%=obj/%.o)
	$(call linkWithNall,base56)
	$(call linkWithNall,checksum)
	$(call linkWithNall,compressor)
	$(call linkWithNall,decompressor)
	$(call linkWithNall,font-encoder)
	$(call linkWithNall,font-extractor)
	$(call linkWithNall,font-kerner)
	$(call linkWithNall,list-encoder)
	$(call linkWithNall,list-extractor)
	$(call linkWithNall,script-encoder)
	$(call linkWithNall,script-extractor)
	$(call linkWithNall,string-scanner)

obj/base56.o:           base56.cpp
obj/checksum.o:         checksum.cpp
obj/compressor.o:       compressor.cpp
obj/decompressor.o:     decompressor.cpp
obj/font-encoder.o:     font-encoder.cpp
obj/font-extractor.o:   font-extractor.cpp
obj/font-kerner.o:      font-kerner.cpp
obj/list-editor.o:      list-editor.cpp
obj/list-encoder.o:     list-encoder.cpp
obj/list-extractor.o:   list-extractor.cpp
obj/script-editor.o:    script-editor.cpp
obj/script-encoder.o:   script-encoder.cpp
obj/script-extractor.o: script-extractor.cpp
obj/string-scanner.o:   string-scanner.cpp

BASS := ../../bass/out/bass
KO_LISTS := chapters commands techniques items classes dragons enemies names parties levels levelsFieldMagic levels4 stats stats_bpi4 stats_bpd4 quantities counts countsKo costsMP costsMP_num costsSP strings_bpp2 strings_bpp4 strings_bpo4 strings_bph4

build: cli
	out/base56
	out/font-encoder
	python3 ../../../bahamut/ko/tools/patch_combat_font_ko.py
	python3 ../../../bahamut/ko/tools/apply_chapter_ko_poc.py
	out/list-encoder
	python3 ../../../bahamut/ko/tools/apply_terrain_ko.py
	python3 ../../../bahamut/ko/tools/collect_glyph_usage.py
	python3 ../../../bahamut/ko/tools/list_prerenderer.py $(KO_LISTS)
	python3 ../../../bahamut/ko/tools/list_prerenderer.py --out-dir ../en/binaries/lists $(KO_LISTS)
	out/script-encoder
	cd ../source && $(BASS) main.asm
	out/checksum
	mkdir -p ../../../bahamut/ko/rom
	cp ../en/rom/bahamut-en.sfc ../../../bahamut/ko/rom/bahamut-ko.sfc

patch:
	$(call delete,../en/rom/bahamut-en-patch.bps)
	beat -create:bps ../en/rom/bahamut-en-patch.bps ../jp/rom/bahamut-jp.sfc ../en/rom/bahamut-en.sfc

clean:
	$(call delete,obj/*)
	$(call delete,out/*)

erase:
	$(call rdelete,../en/binaries)
	$(call rdelete,../en/kerning)

-include obj/*.d
