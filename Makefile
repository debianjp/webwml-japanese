# This Makefile should need no changes from webwml/english/Makefile
# Please send a message to debian-www if you need to modify anything
# so the problem can be fixed.

WMLBASE=.
CUR_DIR=
SUBS=po Bugs CD MailingLists News Pics banners chinese consultants devel \
distrib doc events intro international legal logos mirror misc partners \
ports releases searchtmpl security vote y2k

ifneq "$(wildcard om_svenska/Makefile)" ""
SUBS += om_svenska
endif

include $(WMLBASE)/Make.lang

ifndef SUBLANG
SITEMAP = sitemap.$(LANGUAGE).html
DESTSITEMAP = $(HTMLDIR)/$(SITEMAP)
else
SITEMAP = $(sort $(foreach i,$(SUBLANG),\
	$(patsubst %.wml,%.$(LANGUAGE)-$(i).html,sitemap.wml)))
DESTSITEMAP = $(patsubst %.html,$(HTMLDIR)/%.html,$(SITEMAP))
endif

index.$(LANGUAGE).html: index.wml $(TEMPLDIR)/mainpage.wml \
		$(wildcard News/$(CUR_YEAR)/[0-9]*.wml) $(wildcard $(ENGLISHSRCDIR)/News/$(CUR_YEAR)/[0-9]*.wml) \
		$(wildcard security/$(CUR_YEAR)/dsa-[0-9]*.wml) $(wildcard $(ENGLISHSRCDIR)/security/$(CUR_YEAR)/dsa-[0-9]*.wml) \
		$(TEMPLDIR)/ctime.wml $(TEMPLDIR)/recent_list.wml $(TEMPLDIR)/languages.wml \
		$(ENGLISHSRCDIR)/releases/info
	$(WML) index.wml

$(SITEMAP): $(ENGLISHDIR)/sitemap.wml $(TEMPLDIR)/card.wml \
  $(TEMPLDIR)/links.tags.wml $(TEMPLDIR)/template.wml \
  $(ENGLISHDIR)/releases/info $(ENGLISHDIR)/MailingLists/mklist.tags
ifeq "$(LANGUAGE)" "zh"
	$(subst :.zh,:sitemap.zh,$(WML)) \
          $(shell egrep '^-D (CUR_|CHAR)' .wmlrc) \
            $(shell echo $(ENGLISHDIR) | sed s,./,,)/sitemap.wml
	@echo -n " * Converting: [zh_CN.GB2312], "
	@$(B5TOGB) < sitemap.zh-cn.html.tmp > sitemap.zh-cn.html
	@rm -f sitemap.zh-cn.html.tmp
	@$(TOCN) sitemap.zh-cn.html
	@echo -n "[zh_HK.Big5], "
	@mv -f sitemap.zh-hk.html.tmp sitemap.zh-hk.html
	@$(TOHK) sitemap.zh-hk.html
	@echo "[zh_TW.Big5]."
	@mv -f sitemap.zh-tw.html.tmp sitemap.zh-tw.html
	@$(TOTW) sitemap.zh-tw.html
else
	$(WML) $(shell egrep '^-D (CUR_|CHAR)' .wmlrc) \
          $(shell echo $(ENGLISHDIR) | sed s,./,,)/sitemap.wml
endif

all:: $(SITEMAP)

install:: $(DESTSITEMAP)
ifeq "$(LANGUAGE)" "en"
	test -L $(HTMLDIR)/intl || ln -sf international $(HTMLDIR)/intl
	test -L $(HTMLDIR)/mirrors || ln -sf mirror $(HTMLDIR)/mirrors

install:: $(HTMLDIR)/favicon.ico

$(HTMLDIR)/favicon.ico: favicon.ico
	install -p -m 664 favicon.ico $(HTMLDIR)
endif
