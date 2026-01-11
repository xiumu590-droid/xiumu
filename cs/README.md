# AdGuard DNS 过滤器

以前是*AdGuard 简化域名过滤器*。

由其他几个过滤器（AdGuard Base 过滤器、社交媒体过滤器、跟踪保护过滤器、移动广告过滤器、EasyList 和 EasyPrivacy）组成的过滤器，并经过专门简化，以更好地兼容 DNS 级广告拦截。

过滤器的直接链接：https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt。

请注意，要使用此过滤器，必须支持[基本广告拦截规则语法](https://kb.adguard.com/en/general/how-to-create-your-own-ad-filters)。仅提取主机文件没有多大意义。
这是 [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) 和公共 [AdGuard DNS](https://adguard.com/en/adguard-dns/overview.html) 服务器的默认过滤器。

### 如何手动构建 AdGuard DNS 过滤器

```
yarn install
yarn run build
```

输出被写入 `Filters/filter.txt`.

## DNS过滤器结构

### 广告服务器

#### 这些过滤器列表阻止用于在网站上提供和显示广告的域

* [AdGuard Base filter](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/adservers.txt)

* [AdGuard Base filter — first-party servers](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/adservers_firstparty.txt)

* [AdGuard Base filter — foreign servers](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/foreign.txt)

* [AdGuard Mobile Ads filter](https://adguardteam.github.io/AdguardFilters/MobileFilter/sections/adservers.txt)

* [AdGuard Spanish/Portuguese filter](https://adguardteam.github.io/AdguardFilters/SpanishFilter/sections/adservers.txt)

* [AdGuard Spanish/Portuguese filter — first-party servers](https://adguardteam.github.io/AdguardFilters/FrenchFilter/sections/adservers_firstparty.txt)

* [AdGuard common Cyrillic filters ad servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/common-sections/adservers.txt)

* [AdGuard common Cyrillic filters ad servers — first-party servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/common-sections/adservers_firstparty.txt)

* [AdGuard Russian filter — first-party servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/RussianFilter/sections/adservers_firstparty.txt)

* [AdGuard Ukrainian filter — first-party servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/UkrainianFilter/sections/adservers_firstparty.txt)

* [AdGuard Belarusian language ad servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/Belarusian/sections/filter.txt)

* [AdGuard Bulgarian language ad servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/Bulgarian/sections/filter.txt)

* [AdGuard Kazakh language ad servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/Kazakh/sections/filter.txt)

* [AdGuard Turkish filter](https://adguardteam.github.io/AdguardFilters/TurkishFilter/sections/adservers.txt)

* [AdGuard Turkish filter — first-party servers](https://adguardteam.github.io/AdguardFilters/TurkishFilter/sections/adservers_firstparty.txt)

* [AdGuard French filter](https://adguardteam.github.io/AdguardFilters/FrenchFilter/sections/adservers.txt)

* [AdGuard French filter — first-party servers](https://adguardteam.github.io/AdguardFilters/FrenchFilter/sections/adservers_firstparty.txt)

* [AdGuard Japanese filter](https://adguardteam.github.io/AdguardFilters/JapaneseFilter/sections/adservers.txt)

* [AdGuard Japanese filter — first-party servers](https://adguardteam.github.io/AdguardFilters/JapaneseFilter/sections/adservers_firstparty.txt)

* [AdGuard German filter](https://adguardteam.github.io/AdguardFilters/GermanFilter/sections/adservers.txt)

* [AdGuard Chinese filter](https://adguardteam.github.io/AdguardFilters/ChineseFilter/sections/adservers.txt)

* [AdGuard Chinese filter — first-party servers](https://adguardteam.github.io/AdguardFilters/ChineseFilter/sections/adservers_firstparty.txt)

* [AdGuard Dutch filter](https://adguardteam.github.io/AdguardFilters/DutchFilter/sections/adservers.txt)

* [AdGuard Dutch filter — first-party servers](https://adguardteam.github.io/AdguardFilters/DutchFilter/sections/adservers_firstparty.txt)

* [EasyList](https://raw.githubusercontent.com/easylist/easylist/master/easylist/easylist_adservers.txt)

* [EasyList — third-party servers](https://raw.githubusercontent.com/easylist/easylist/master/easylist/easylist_thirdparty.txt)

* [EasyList - specific block](https://raw.githubusercontent.com/easylist/easylist/refs/heads/master/easylist/easylist_specific_block.txt)

* [EasyList - adult block](https://raw.githubusercontent.com/easylist/easylist/refs/heads/master/easylist_adult/adult_specific_block.txt)

* [EasyList — adult third-party servers](https://raw.githubusercontent.com/easylist/easylist/master/easylist_adult/adult_adservers.txt)

* [EasyList — adult popup servers](https://raw.githubusercontent.com/easylist/easylist/master/easylist_adult/adult_adservers_popup.txt)

* [EasyList Germany](https://raw.githubusercontent.com/easylist/easylistgermany/master/easylistgermany/easylistgermany_adservers.txt)

* [EasyList Hebrew](https://raw.githubusercontent.com/easylist/EasyListHebrew/master/adguard_hosts.txt)

* [EasyList Italy](https://raw.githubusercontent.com/easylist/easylistitaly/master/easylistitaly/easylistitaly_adservers.txt)

* [EasyList China](https://raw.githubusercontent.com/easylist/easylistchina/master/easylistchina.txt)

* [EasyList Dutch](https://raw.githubusercontent.com/easylist/easylistdutch/master/easylistdutch/block_third_party_server.txt)

* [ABPindo](https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/src/advert/adservers.txt)

* [ABPindo — third-party servers](https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/src/advert/thirdparty.txt)

* [AdblockID](https://raw.githubusercontent.com/realodix/AdBlockID/master/src/adservers.adfl)

* [hostsVN](https://raw.githubusercontent.com/bigdargon/hostsVN/master/filters/adservers.txt)

* [hostsVN Threat](https://raw.githubusercontent.com/bigdargon/hostsVN/master/extensions/threat/filter.txt)

* [List-KR filter](https://cdn.jsdelivr.net/gh/List-KR/List-KR@latest/filters-share/1st_domains.txt)

* [List-KR filter - third-party servers](https://cdn.jsdelivr.net/gh/List-KR/List-KR@latest/filters-share/3rd_domains.txt)

### 追踪服务器

#### 这些过滤器列出了用于跟踪和分析的阻止域
* [AdGuard Tracking Protection filter — third-party trackers](https://adguardteam.github.io/AdguardFilters/SpywareFilter/sections/tracking_servers.txt)

* [AdGuard Tracking Protection filter — first-party trackers](https://adguardteam.github.io/AdguardFilters/SpywareFilter/sections/tracking_servers_firstparty.txt)

* [AdGuard Tracking Protection filter — mobile trackers](https://adguardteam.github.io/AdguardFilters/SpywareFilter/sections/mobile.txt)

* [EasyPrivacy](https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_trackingservers.txt)

* [EasyPrivacy — third-party trackers 1](https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_thirdparty.txt), [2](https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_trackingservers_admiral.txt)

* [EasyPrivacy — international trackers](https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_trackingservers_international.txt)

* [EasyPrivacy — third-party international](https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_thirdparty_international.txt)

### 加密矿工

#### 这些过滤器列表用于针对加密货币矿工
* [AdGuard Base filter cryptominers](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/cryptominers.txt)

### 异常

#### 这些列表用于排除导致严重网站损坏的域

* [Exclusion rules](https://github.com/AdguardTeam/AdGuardSDNSFilter/blob/master/Filters/exclusions.txt)
* [Exception rules](https://github.com/AdguardTeam/AdGuardSDNSFilter/blob/master/Filters/exceptions.txt)

### 地区名单

#### 这些过滤器列表可阻止特定语言组网站上的各种类型的广告、跟踪、诈骗和恶意软件

* [Frellwits Swedish Filter](https://raw.githubusercontent.com/lassekongo83/Frellwits-filter-lists/master/Frellwits-Swedish-Hosts-File.txt)
* [Persian Blocker Hosts](https://raw.githubusercontent.com/MasterKia/PersianBlocker/main/PersianBlockerHosts.txt)

### 其他的

* [Additional rules](https://github.com/AdguardTeam/AdGuardSDNSFilter/blob/master/Filters/rules.txt)

## AdGuard DNS 弹出主机过滤器

DNS 级别的阻止是一种粗暴的方法，从用户的角度来看，它会使被阻止的网站看起来好像出现了故障。虽然这种方法可能足以阻止对跟踪器的子请求，但当用户尝试直接访问被阻止的域时，其效果较差。

此过滤器会阻止用户倾向于打开的域（更准确地说，它们是违背用户意愿打开的），并将它们重定向到指定的“阻止页面”，该页面提供有关阻止原因的解释。

尽管重定向到不同的 IP 地址并不是理想的解决方案，但我们希望[结构化错误提案](https://datatracker.ietf.org/doc/draft-ietf-dnsop-structed-dns-error/) 能够获得动力。这将使我们能够实施更好的解决方案。

## AdGuard DNS 弹出主机过滤器结构

AdGuard DNS 弹出窗口主机过滤器仅包含包含所提供列表中的修饰符“popup”、“all”和“document”的规则。此选择实际上意味着这些规则针对在主框架中打开的站点。

* [AdGuard Base filter ad servers](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/adservers.txt)
* [AdGuard Base filter ad servers first-party](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/adservers_firstparty.txt)
* [AdGuard Base filter ad servers foreign](https://adguardteam.github.io/AdguardFilters/BaseFilter/sections/foreign.txt)
* [EasyList ad servers](https://raw.githubusercontent.com/easylist/easylist/master/easylist/easylist_adservers.txt)
* [EasyList adult ad servers popup](https://raw.githubusercontent.com/easylist/easylist/master/easylist_adult/adult_adservers_popup.txt)
* [AdGuard Mobile Ads filter ad servers](https://adguardteam.github.io/AdguardFilters/MobileFilter/sections/adservers.txt)
* [AdGuard common Cyrillic filters ad servers](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/common-sections/adservers.txt)
* [AdGuard Russian filter ad servers first-party](https://adguardteam.github.io/AdguardFilters/CyrillicFilters/RussianFilter/sections/adservers_firstparty.txt)
* [Liste FR](https://raw.githubusercontent.com/easylist/listefr/master/liste_fr.txt)
* [ABPindo ad servers](https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/src/advert/adservers.txt)
* [ABPindo ad servers third-party](https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/src/advert/thirdparty.txt)
