include $(TOPDIR)/rules.mk

PKG_NAME:=ffwizard-backend
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/ffwizard-backend/template
  SECTION:=freifunk
  CATEGORY:=freifunk
  TITLE:=freifunk ffwizard backend
endef

define Package/ffwizard-backend/description
  freifunk ffwizard backend
endef

define Package/ffwizard-backend
  $(call Package/ffwizard-backend/template)
  MENU:=1
  DEPENDS:=+uhttpd +uhttpd-mod-ubus \
  +rpcd +rpcd-mod-file +rpcd-mod-iwinfo +rpcd-mod-rpcsys +iwinfo \
  @IPV6
endef

define Package/ffwizard-backend/conffiles
/etc/ffwizard/config.json
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/ffwizard-backend/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/ffwizard.d $(1)/etc/ffwizard
	$(INSTALL_BIN) files/etc/ffwizard.d/10-system.sh $(1)/etc/ffwizard.d/
	$(INSTALL_BIN) files/sbin/ffwizard_load $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) files/rpcd/ffwizard $(1)/usr/libexec/rpcd/ffwizard
endef

$(eval $(call BuildPackage,ffwizard-backend))
