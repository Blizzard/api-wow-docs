# WoW Community Web API

This is the documentation for the RESTful APIs exposed through the World of
Warcraft community site as a service to the World of Warcraft community.

To view the inlined gist json examples you should view this document at
[http://blizzard.github.com/api-wow-docs/](http://blizzard.github.com/api-wow-docs/).

## Introduction

The Blizzard Community Platform API provides a number of resources for
developers and Wow enthusiasts to gather data about their characters,
guilds and arena teams. This documentation is primarily for developers
and third parties.

Blizzard's epic gaming experiences often take place in game, but can
lead to rewarding and lasting experiences out of game as well. Through
exposing key sets of data, we can enable the community to create
extended communities to continue that epic experience.

## Features

Before getting started with the Community Platform API, programmers
must first understand how the API is organized and how it works. The
following sections provide a high level overview of the features of
this API. It is recommended that the reader have knowledge of the HTTP
protocol as well as a general understanding of web technologies.

### REST

The API is mostly RESTful. Data is exposed in the form of URIs that
represent resources and can be fetched with HTTP clients (like web
browsers). At this time, the API is limited to read-only operations.

The character and guild API resources do honor HTTP requests that
contain the "If-Modified-Since" header.

### Access and Regions

To access the API, HTTP requests can be made to specific URLs and
resources exposed on the regional Battle.net domains.

The data available through the API is limited to the region that it is
in. Hence, US APIs accessed through us.battle.net will only contain
data within US battlegroups and realms. Support for locales is limited
to those supported on the World of Warcraft community sites.

#### Localization

All of the API resources provided adhere to the practice of providing
localized strings using the locale query string parameter. The locales
supported vary from region to region and align with those supported on
the community sites.

To access a different region just provide the `locale=pt_BR` (for
example) query parameter.

*Example URL for the europe character race list localized in French*
```plain
http://eu.battle.net/api/wow/data/character/races?locale=fr_FR
```

#### Region Host List
<table>
  <tr>
    <th>Region</th>
	<th>Host</th>
	<th>Available Locales</th>
  </tr>
  <tr>
    <td>US</td>
	<td>us.battle.net</td>
	<td>
	  <a href="http://us.battle.net/api/wow/data/character/races?locale=en_US">en_US</a><br/>
	  <a href="http://us.battle.net/api/wow/data/character/races?locale=es_MX">es_MX</a><br/>
	  <a href="http://us.battle.net/api/wow/data/character/races?locale=pt_BR">pt_BR</a>
	</td>
  </tr>
  <tr>
    <td>Europe</td>
	<td>eu.battle.net</td>
	<td>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=en_GB">en_GB</a><br/>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=es_ES">es_ES</a><br/>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=fr_FR">fr_FR</a><br/>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=ru_RU">ru_RU</a><br/>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=de_DE">de_DE</a><br/>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=pt_PT">pt_PT</a><br/>
	  <a href="http://eu.battle.net/api/wow/data/character/races?locale=it_IT">it_IT</a>
	</td>
  </tr>
  <tr>
    <td>Korea</td>
	<td>kr.battle.net</td>
	<td>
	  <a href="http://kr.battle.net/api/wow/data/character/races?locale=ko_KR">ko_KR</a>
	</td>
  </tr>
  <tr>
    <td>Taiwan</td>
	<td>tw.battle.net</td>
	<td>
	  <a href="http://tw.battle.net/api/wow/data/character/races?locale=zh_TW">zh_TW</a>
	</td>
  </tr>
  <tr>
    <td>China</td>
	<td>www.battlenet.com.cn</td>
	<td>
	  <a href="http://www.battlenet.com.cn/api/wow/data/character/races?locale=zh_CN">zh_CN</a>
	</td>
  </tr>
</table>

### Throttling

Consumers of the API can make a limited number of requests per day, as
stated in the API Policy and Terms of Use. For anonymous consumers of
the API, the number of requests that can be made per day is set to
3,000. Once that threshold is reached, depending on site activity and
performance, subsequent requests may be denied. High limits are
available to registered applications.

### Authentication

Although most of the application can be accessed without any form of
authentication, we do support a form application registration and
authentication. Application authentication involves creating and
including an application identifier and a request signature and
including those values with the request headers.

The primary benefit to making requests as an authenticated application
is that you can make more requests per day.

#### Application Registration

To send authenticated request you first need to register an
application. Because registration isn't automated, application
registration is limited to those who meet the following criteria:

* You plan on making requests from one or more IP addresses. (e.g. a
  production environment and development environment)

* You can justify making more than 2,000 requests per day from one or
  more IP addresses.

Registering an application is a matter of providing a description of
the application, how you plan on using the API and your contact
information to
[api-support@blizzard.com](mailto:api-support@blizzard.com) with the
subject "Application Registration Request". Once we receive your
request, we will contact you to either provide additional information
or with application keys to use.

#### Authentication Process

To authenticate a request, simple include the "Authorization" header
with your application identifier and the request signature.

*An example authenticated request*

    GET /api/wow/character/Medivh/Thrall HTTP/1.1
    Host: us.battle.net
    Date: Fri, 10 Jun 2011 20:59:24 GMT
    Authorization: BNET c1fbf21b79c03191d:+3fE0RaKc+PqxN0gi8va5GQC35A=

In the above exmple, the value of the Authorization header has three
parts `"BNET"`, `"c1fbf21b79c03191d"` and
`"+3fE0RaKc+PqxN0gi8va5GQC35A="`. The first part is a processing
directive for the Authorization header. The second and third values
are the application public key and the request signature. The
application public key is assigned by Blizzard during the application
registration process. The signature is generated with each request and
is discribed by the following algorithm.

    UrlPath = <HTTP-Request-URI, from the port to the query string>
    
    StringToSign = HTTP-Verb + "\n" +
        Date + "\n" +
        UrlPath + "\n";
    
    Signature = Base64( HMAC-SHA1( UTF-8-Encoding-Of( PrivateKey ), StringToSign ) );
    
    Header = "Authorization: BNET" + " " + PublicKey + ":" + Signature;

The above process can be seen in action by filling in the blanks:

    UrlPath = "/api/wow/realm/status"
    
    StringToSign = "GET" + "\n" +
        "Fri, 10 Jun 2011 21:37:34 GMT" + "\n" +
        UrlPath + "\n";
    
    Signature = Base64( HMAC-SHA1( UTF-8-Encoding-Of( "examplesecret" ), StringToSign ) );
    
    Header = "Authorization: BNET" + " " + "examplekey" + ":" + Signature;

The date timestamp used in the above algorithm and example is the
value of the Date HTTP header. The two date values, the first being
used to sign the request and the second as sent with the request
headers, must be the same and within 5 minutes of the current GMT
time.

**Important** We strongly advise that client library developers make
secure requests using SSL whenever application authentication is used.

### Formats and Protocols

Data returned in the response message is provided in JSON
format. Please refer to the examples provided with each API section
for additional information.

### Error Handling

Although several of the API resources have specific error responses
that correspond to specific situations, there are several generic
error responses that you should be aware of.

Errors are returned as JSON objects that contain "status" and "reason"
attributes. The value of the "status" attribute will always be
"nok". The reason will be an english string that may be, but is not
limited to, one of the following strings.

<table>
  <tr>
    <th>Code</th>
    <th>Message</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>500</td>
    <td>Invalid Application</td>
    <td>A request was made including application identification information, but either the application key is invalid or missing.</td>
  </tr>
  <tr>
    <td>500</td>
    <td>Invalid application permissions.</td>
	<td>A request was made to an API resource that requires a higher application permission level.</td>
  </tr>
  <tr>
    <td>500</td>
    <td>Access denied, please contact api-support@blizzard.com</td>
	<td>The application or IP address has been blocked from making further requests. This ban may not be permanent.</td>
  </tr>
  <tr>
    <td>404</td>
    <td>When in doubt, blow it up. (page not found)</td>
	<td>A request was made to a resource that doesn't exist.</td>
  </tr>
  <tr>
    <td>500</td>
    <td>If at first you don't succeed, blow it up again. (too many requests)</td>
	<td>The application or IP has been throttled.</td>
  </tr>
  <tr>
    <td>500</td>
    <td>Have you not been through enough? Will you continue to fight what you cannot defeat? (something unexpected happened)</td>
	<td>There was a server error or equally catastrophic exception preventing the request from being fulfilled.</td>
  </tr>
  <tr>
    <td>500</td>
    <td>Invalid authentication header.</td>
	<td>The application authorization information was mallformed or missing when expected.</td>
  </tr>
  <tr>
    <td>500</td>
    <td>Invalid application signature.</td>
	<td>The application request signature was missing or invalid. This will also be thrown if the request date outside of a 15 second window from the current GMT time.</td>
  </tr>
</table>

*An example API request and and error response*
```plain
GET /api/wow/data/boss/45 HTTP/1.1
Host: us.battle.net
<http headers>
```
```plain
HTTP/1.1 404 Not Found
<http headers>

{"status":"nok", "reason": "When in doubt, blow it up. (page not found)"}
```

## Achievement API

```plain
URL = Host + "/api/wow/achievement/" + AchievementID
```

This provides data about an individual achievement.

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/achievement/2144](http://us.battle.net/api/wow/achievement/2144)</dd>
  <dt>Example Data</dt>
  <dd>[achievement.json](https://gist.github.com/3772776#file_achievement.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=achievement.json"></script>

## Auction API

Auction APIs currently provide rolling batches of data about current
auctions. Fetching auction dumps is a two step process that involves
checking a per-realm index file to determine if a recent dump has been
generated and then fetching the most recently generated dump file if
necessary.

#### Auction Data Status

This API resource provides a per-realm list of recently generated
auction house data dumps.

```plain
URL = Host + "/api/wow/auction/data/" + realm
```

There are no required query string parameters when accessing this
resource.

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/auction/data/medivh](http://us.battle.net/api/wow/auction/data/medivh)</dd>
  <dt>Example Data</dt>
  <dd>[auction-data.json](https://gist.github.com/3772776#file_auction_data.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=auction-data.json"></script>

#### Auction Data Files

The current auctions data is represented as JSON structures containing
auction data for the three auctions houses available on each realm. This file
is served as a static file from the url listed in the above request. This means
that it does not respond to locale or json parameters because it is not part of
the api service. Requests to the actual data file also do not count towards any
request limits.

## BattlePet API

### Abilities

```plain
URL = Host + "/api/wow/battlePet/ability/" + AbilityID
```

This provides data about a individual battle pet ability ID. We do not provide
the tooltip for the ability yet. We are working on a better way to provide this
since it depends on your pet's species, level and quality rolls.

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/battlePet/ability/640](http://us.battle.net/api/wow/battlePet/ability/640)</dd>
  <dt>Example Data</dt>
  <dd>[battlePet-ability.json](https://gist.github.com/3772776#file_battle_pet_ability.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=battlePet-ability.json"></script>

### Species

```plain
URL = Host + "/api/wow/battlePet/species/" + SpeciesID
```

This provides the data about an individual pet species. The species ids can be
found your character profile using the options `pets` field. Each species also
has data about what it's 6 abilities are.

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/battlePet/species/258](http://us.battle.net/api/wow/battlePet/species/258)</dd>
  <dt>Example Data</dt>
  <dd>[battlePet-species.json](https://gist.github.com/3772776#file_battle_pet_species.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=battlePet-species.json"></script>

### Stats

```plain
URL = Host + "/api/wow/battlePet/stats/" + SpeciesID
```

#### Optional Parameters
<table>
  <tr>	
    <th>Parameter</th>
    <th>Default</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>level</td>
    <td>1</td>
    <td>The Pet's level</td>
  </tr>
  <tr>
    <td>breedId</td>
    <td>3</td>
    <td>The Pet's breed (can be retrieved from the character profile api)</td>
  </tr>
  <tr>
    <td>qualityId</td>
    <td>1</td>
    <td>The Pet's quality (can be retrieved from the character profile api)</td>
  </tr>
</table>

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/battlePet/stats/258?level=25&breedId=5&qualityId=4](http://us.battle.net/api/wow/battlePet/stats/258?level=25&breedId=5&qualityId=4)</dd>
  <dt>Example Data</dt>
  <dd>[battlePet-stats.json](https://gist.github.com/3772776#file_battle_pet_stats.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=battlePet-stats.json"></script>

## Challenge Mode API

The Challenge Mode API displays the same information as the leader boards on the
wow game site.

### Realm Leaderboard

```plain
URL = Host + "/api/wow/challenge/" + Realm

Realm = <proper realm name> | <normalized realm name>
```

The data in this request has data for all 9 challenge mode maps (currently). The map
field includes the current medal times for each dungeon. Inside each ladder we provide
data about each character that was part of each run. The character data includes the
current cached spec of the character while the member field includes the spec of the
character during the challenge mode run.

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/challenge/medivh](http://us.battle.net/api/wow/challenge/medivh)</dd>
  <dt>Example Data</dt>
  <dd>[challenge.json](https://gist.github.com/3772776#file_challenge.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=challenge.json"></script>

### Region Leaderboard

The region leaderboard has the exact same data format as the realm leaderboards
except there is no `realm` field. It is simply the top 100 results gathered for
each map for all of the available realm leaderboards in a region.

```plain
URL = Host + "/api/wow/challenge/region"
```
## Character Profile API

The Character Profile API is the primary way to access character
information. This Character Profile API can be used to fetch a single
character at a time through an HTTP GET request to a URL describing
the character profile resource. By default, a basic dataset will be
returned and with each request and zero or more additional fields can
be retrieved. To access this API, craft a resource URL pointing to the
character whos information is to be retrieved.

```plain
URL = Host + "/api/wow/character/" + Realm + "/" + CharacterName

Realm = <proper realm name> | <normalized realm name>
```

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn</dd>
  <dt>Example Data</dt>
  <dd>[character.json](https://gist.github.com/3772776#file_character.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character.json"></script>

#### Optional Fields

This section contains a list of the optional fields that can be
requested through the mentioned "fields" query string parameter.

<table>
  <tr>
    <th>Field</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><a href="#character-profile-api/achievements">achievements</a></td>
    <td>A map of achievement data including completion timestamps and criteria information.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/appearance">appearance</a></td>
    <td>A map of values that describes the face, features and helm/cloak display preferences and attributes.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/feed">feed</a></td>
    <td>The activity feed of the character.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/guild">guild</a></td>
  	<td>A summary of the guild that the character belongs to. If the character does not belong to a guild and this field is requested, this field will not be exposed.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/hunterPets">hunterPets</a></td>
    <td>A list of all of the combat pets obtained by the character.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/items">items</a></td>
    <td>A list of items equipted by the character. Use of this field will also include the average item level and average item level equipped for the character.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/mounts">mounts</a></td>
    <td>A list of all of the mounts obtained by the character.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/pets">pets</a></td>
    <td>A list of the battle pets obtained by the character.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/petSlots">petSlots</a></td>
    <td>Data about the current battle pet slots on this characters account.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/professions">professions</a></td>
    <td>A list of the character's professions. It is important to note that when this information is retrieved, it will also include the known recipes of each of the listed professions.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/progression">progression</a></td>
    <td>A list of raids and bosses indicating raid progression and completedness.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/pvp">pvp</a></td>
    <td>A map of pvp information including arena team membership and rated battlegrounds information.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/quests">quests</a></td>
    <td>A list of quests completed by the character.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/reputation">reputation</a></td>
    <td>A list of the factions that the character has an associated reputation with.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/stats">stats</a></td>
  	<td>A map of character attributes and stats.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/talents">talents</a></td>
  	<td>A list of talent structures.</td>
  </tr>
  <tr>
    <td><a href="#character-profile-api/titles">titles</a></td>
    <td>A list of the titles obtained by the character including the currently selected title.</td>
  </tr>
</table>

*An example Character Profile request with several addtional fields.*
```plain
http://us.battle.net/api/wow/character/Medivh/Uther?fields=guild,items,professions,reputation,stats
```

### achievements

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=achievements</dd>
  <dt>Example Data</dt>
  <dd>[character-achievements.json](https://gist.github.com/3772776#file_character_achievements.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-achievements.json"></script>

### appearance

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=appearance</dd>
  <dt>Example Data</dt>
  <dd>[character-appearance.json](https://gist.github.com/3772776#file_character_appearance.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-appearance.json"></script>

### feed

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=feed</dd>
  <dt>Example Data</dt>
  <dd>[character-feed.json](https://gist.github.com/3772776#file_character_feed.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-feed.json"></script>

### guild

When a guild is requested, a map is returned with key/value pairs that
describe a basic set of guild information. Note that the rank of the
character is not included in this block as it describes a guild and
not a membership of the guild. To retreive the character's rank within
the guild, you must specific a seperate request to the guild profile
resource.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=guild</dd>
  <dt>Example Data</dt>
  <dd>[character-guild.json](https://gist.github.com/3772776#file_character_guild.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-guild.json"></script>

### hunterPets

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=hunterPets</dd>
  <dt>Example Data</dt>
  <dd>[character-hunterPets.json](https://gist.github.com/3772776#file_character_hunterPets.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-hunterPets.json"></script>

### items

When the items field is used, a map structure is returned that
contains information on the equipped items of that character as well
as the average item level of the character.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=items</dd>
  <dt>Example Data</dt>
  <dd>[character-items.json](https://gist.github.com/3772776#file_character_items.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-items.json"></script>

### mounts

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=mounts</dd>
  <dt>Example Data</dt>
  <dd>[character-mounts.json](https://gist.github.com/3772776#file_character_mounts.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-mounts.json"></script>

### pets

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=pets</dd>
  <dt>Example Data</dt>
  <dd>[character-pets.json](https://gist.github.com/3772776#file_character_pets.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-pets.json"></script>

### petSlots

The pet slot contains which slot it is and whether the slot is empty
or locked. We also include the battlePetId which is unique for this
character and can be used to match a battlePetId in the pets field for
this character. The ability list is the list of 3 active abilities on
that pet. If the pet is not high enough level than it will always be
the first three abilities that the pet has.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=petSlots</dd>
  <dt>Example Data</dt>
  <dd>[character-petSlots.json](https://gist.github.com/3772776#file_character_petSlots.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-petSlots.json"></script>

### professions

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=professions</dd>
  <dt>Example Data</dt>
  <dd>[character-professions.json](https://gist.github.com/3772776#file_character_professions.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-professions.json"></script>

### progression

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=progression</dd>
  <dt>Example Data</dt>
  <dd>[character-progression.json](https://gist.github.com/3772776#file_character_progression.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-progression.json"></script>

### pvp

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=pvp</dd>
  <dt>Example Data</dt>
  <dd>[character-pvp.json](https://gist.github.com/3772776#file_character_pvp.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-pvp.json"></script>

### quests

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=quests</dd>
  <dt>Example Data</dt>
  <dd>[character-quests.json](https://gist.github.com/3772776#file_character_quests.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-quests.json"></script>

### reputation

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=reputation</dd>
  <dt>Example Data</dt>
  <dd>[character-reputation.json](https://gist.github.com/3772776#file_character_reputation.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-reputation.json"></script>

### stats

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=stats</dd>
  <dt>Example Data</dt>
  <dd>[character-stats.json](https://gist.github.com/3772776#file_character_stats.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-stats.json"></script>

### talents

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=talents</dd>
  <dt>Example Data</dt>
  <dd>[character-talents.json](https://gist.github.com/3772776#file_character_talents.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-talents.json"></script>

### titles

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/character/test-realm/Peratryn?fields=titles</dd>
  <dt>Example Data</dt>
  <dd>[character-titles.json](https://gist.github.com/3772776#file_character_titles.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=character-titles.json"></script>

## Item API

The item API provides data about items and item sets.

### Individual Item

The item API provides detailed item information. This includes item
set information if this item is part of a set.

```plain
URL = Host + "/api/wow/item/" + ItemId
```

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/item/18803](http://us.battle.net/api/wow/item/18803)</dd>
  <dt>Example Data</dt>
  <dd>[item.json](https://gist.github.com/3772776#file_item.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=item.json"></script>

### Item Set

The item set data provides the data for an item set.

```plain
URL = Host + "/api/wow/item/set/" + SetId
```

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/item/set/1060](http://us.battle.net/api/wow/item/set/1060)</dd>
  <dt>Example Data</dt>
  <dd>[item-set.json](https://gist.github.com/3772776#file_item_set.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=item-set.json"></script>

## Guild Profile API

The guild profile API is the primary way to access guild
information. This guild profile API can be used to fetch a single
guild at a time through an HTTP GET request to a url describing the
guild profile resource. By default, a basic dataset will be returned
and with each request and zero or more additional fields can be
retrieved. To access this API, craft a resource URL pointing to the
guild whos information is to be retrieved.

```plain
URL = Host + "/api/wow/guild/" + Realm + "/" + GuildName

Realm = <proper realm name> | <normalized realm name>
```

There are no required query string parameters when accessing this
resource, although the "fields" query string parameter can optionally
be passed to indicate that one or more of the optional datasets is to
be retrieved. Those additional fields are listed in the subsection
titled "Optional Fields".

*An example Guild Profile request and response.*
```plain
GET /api/wow/guild/Medivh/Knights%20of%20the%20Silver%20Hand
Host: us.battle.net
HTTP/1.1 200 OK
<http headers>
```
```json
{ "name":"Knights of the Silver Hand", "level":25, "realm":"Bronzebeard", "battlegroup":"Ruin", "side":0, "achievementPoints":800 }
```

The core dataset returned includes the guild's name, level, faction
and achievement points.

#### Optional Fields

This section contains a list of the optional fields that can be
requested.

<table>
  <tr>
    <th>Field</th>
	<th>Description</th>
  </tr>
  <tr>
    <td><a href="#guild-profile-api/members">members</a></td>
	<td>A list of characters that are a member of the guild</td>
  </tr>
  <tr>
    <td><a href="#guild-profile-api/achievements">achievements</a></td>
	<td>A set of data structures that describe the achievements earned by the guild.</td>
  </tr>
  <tr>
    <td><a href="#guild-profile-api/news">news</a></td>
	<td>A set of data structures that describe the news feed of the guild.</td>
  </tr>
  <tr>
    <td><a href="#guild-profile-api/challenge">challenge</a></td>
	<td>The top 3 challenge mode guild run times for each challenge mode map.</td>
  </tr>
</table>
  
*An example Guild Profile request with several addtional fields.*
```plain
http://us.battle.net/api/wow/guild/Medivh/Knights%20of%20the%20Silver%20Hand?fields=achievements,members
```

### members

When the members list is requested, a list of character objects is
returned. Each object in the returned members list contains a
character block as well as a rank field.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/guild/test-realm/Test%20Guild?fields=members</dd>
  <dt>Example Data</dt>
  <dd>[guild-members.json](https://gist.github.com/3772776#file_guild_members.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=guild-members.json"></script>

### achievements

When requesting achievement data, several sets of data will be
returned.

* *achievementsCompleted* A list of achievement ids.

* *achievementsCompletedTimestamp* A list of timestamps whose places
   correspond to the achievement ids in the "achievementsCompleted"
   list. The value of each timestamp indicates when the related
   achievement was earned by the guild.

* *criteria* A list of criteria ids that can be used to determine the
   partial completedness of guild achievements.

* *criteriaQuantity* A list of values associated with a given
   achievement criteria. The position of a value corresponds to the
   position of a given achivement criteria.

* *criteriaTimestamp* A list of timestamps where the value represents
   when the criteria was considered complete. The position of a value
   corresponds to the position of a given achivement criteria.

* *criteriaCreated* A list of timestamps where the value represents
   when the criteria was considered started. The position of a value
   corresponds to the position of a given achivement criteria.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/guild/test-realm/Test%20Guild?fields=achievements</dd>
  <dt>Example Data</dt>
  <dd>[guild-achievements.json](https://gist.github.com/3772776#file_guild_achievements.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=guild-achievements.json"></script>

### news

When the news feed is requested, you receive a list of news
objects. Each one has a type, a timestamp, and then some other data
depending on the type: itemId, achievement object, etc.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/guild/test-realm/Test%20Guild?fields=news</dd>
  <dt>Example Data</dt>
  <dd>[guild-news.json](https://gist.github.com/3772776#file_guild_news.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=guild-news.json"></script>

### challenge

The challenge field provides the top three guild run times for each challenge mode map that is available.

<dl>
  <dt>Example URL</dt>
  <dd>/api/wow/guild/test-realm/Test%20Guild?fields=challenge</dd>
  <dt>Example Data</dt>
  <dd>[guild-challenge.json](https://gist.github.com/3772776#file_guild_challenge.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=guild-challenge.json"></script>

## PVP API

PVP APIs currently provide arena team and ladder information.

### Arena Team API

The Arena Team API provides detailed arena team information.

```plain
TeamSize = "2v2" | "3v3" | "5v5"
URL = Host + "/api/wow/arena/" + Realm + "/" + TeamSize + "/" + TeamName
```

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/arena/bonechewer/2v2/Samurai%20Jack](http://us.battle.net/api/wow/arena/bonechewer/2v2/Samurai%20Jack)</dd>
  <dt>Example Data</dt>
  <dd>[pvp-arena-team.json](https://gist.github.com/3772776#file_pvp_arena_team.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=pvp-arena-team.json"></script>

#### Arena Ladder API

The Arena Team Ladder API provides arena ladder information for a
battlegroup.

```plain
TeamSize = "2v2" | "3v3" | "5v5"
URL = Host + "/api/wow/pvp/arena/" + Battlegroup + "/" + TeamSize
```

Optional Query String Parameters

* *page* Which page of results to return (defaults to 1)

* *size* How many results to return per page (defaults to 50)

* *asc* Whether to return the results in ascending order. Defaults to
   "true", accepts "true" or "false"

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/pvp/arena/ruin/2v2](http://us.battle.net/api/wow/pvp/arena/ruin/2v2)</dd>
  <dt>Example Data</dt>
  <dd>[pvp-arena-ladder.json](https://gist.github.com/3772776#file_pvp_arena_ladder.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=pvp-arena-ladder.json"></script>

#### Rated Battleground Ladder API

The Rated Battleground Ladder API provides ladder information for a region.

```plain
URL = Host + "/api/wow/pvp/ratedbg/ladder"
```

Optional Query String Parameters

* *page* Which page of results to return (defaults to 1)

* *size* How many results to return per page (defaults to 50)

* *asc* Whether to return the results in ascending order. Defaults to
  "true", accepts "true" or "false"

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/pvp/ratedbg/ladder](http://us.battle.net/api/wow/pvp/ratedbg/ladder)</dd>
  <dt>Example Data</dt>
  <dd>[pvp-ratedbg-ladder.json](https://gist.github.com/3772776#file_pvp_ratedbg_ladder.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=pvp-ratedbg-ladder.json"></script>

## Quest API

The quest API provides detailed quest information.

```plain
URL = Host + "/api/wow/quest/" + QuestId
```

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/quest/13146](http://us.battle.net/api/wow/quest/13146)</dd>
  <dt>Example Data</dt>
  <dd>[quest.json](https://gist.github.com/3772776#file_quest.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=quest.json"></script>

## Realm Status API

The realm status API allows developers to retrieve realm status
information. This information is limited to whether or not the realm
is up, the type and state of the realm, the current population, and
the status of the two world pvp zones.

```plain
URL = Host + "/api/wow/realm/status"
```

There are no required query string parameters when accessing this
resource, although the "realms" query string parameter can optionally
be passed to limit the realms returned to one or more.

#### Pvp Area Status Fields

* *area* An internal id of this zone.

* *controlling-faction* Which faction is controlling the zone at the
   moment.

* *status* The current status of the zone. The possible values are

  * -1: Unknown
  * 0: Idle
  * 1: Populating
  * 2: Active
  * 3: Concluded

* *next* A timestamp of when the next battle starts.

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/realm/status](http://us.battle.net/api/wow/realm/status)</dd>
  <dt>Example Data</dt>
  <dd>[realm-status.json](https://gist.github.com/3772776#file_realm_status.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=realm-status.json"></script>

## Recipe API

The recipe API provides basic recipe information.

```plain
URL = Host + "/api/wow/recipe/" + RecipeId
```

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/recipe/33994](http://us.battle.net/api/wow/recipe/33994)</dd>
  <dt>Example Data</dt>
  <dd>[recipe.json](https://gist.github.com/3772776#file_recipe.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=recipe.json"></script>

## Spell API

The spell API provides some information about spells.

```plain
URL = Host + "/api/wow/spell/" + SpellId
```

<dl>
  <dt>Example URL</dt>
  <dd>[/api/wow/spell/8056](http://us.battle.net/api/wow/spell/8056)</dd>
  <dt>Example Data</dt>
  <dd>[spell.json](https://gist.github.com/3772776#file_spell.json)</dd>
</dl>
<script src="https://gist.github.com/3772776.js?file=spell.json"></script>

## Data Resources

The data APIs provide information that can compliment profile
information to provide structure, definition and context.

### Battlegroups

The battlegroups data API provides the list of battlegroups for this
region. Please note the trailing / on this request url.

```plain
URL = Host + "/api/wow/data/battlegroups/"
```

### Character Races

The character races data API provides a list of character races.

```plain
URL = Host + "/api/wow/data/character/races"
```

### Character Classes

The character classes data API provides a list of character classes.

```plain
URL = Host + "/api/wow/data/character/classes"
```

### Character Achievements

The character achievements data API provides a list of all of the
achievements that characters can earn as well as the category
structure and hierarchy.

```plain
URL = Host + "/api/wow/data/character/achievements"
```

### Guild Rewards

The guild rewards data API provides a list of all guild rewards.

```plain
URL = Host + "/api/wow/data/guild/rewards"
```

### Guild Perks

The guild perks data API provides a list of all guild perks.

```plain
URL = Host + "/api/wow/data/guild/perks"
```

### Guild Achievements

The guild achievements data API provides a list of all of the
achievements that guilds can earn as well as the category structure
and hierarchy.

```plain
URL = Host + "/api/wow/data/guild/achievements"
```

### Item Classes

The item classes data API provides a list of item classes.

```plain
URL = Host + "/api/wow/data/item/classes"
```

### Talents

The talents data API provides a list of talents, specs and glyphs
for each class.

```plain
URL = Host + "/api/wow/data/talents"
```

### Pet Types

The different bat pet types (including what they are strong and weak
against)

```plain
URL = Host + "/api/wow/data/pet/types"
```

## Policies and Support
### Support

For questions about the API, please use the Community Platform API
forums as a platform to ask questions and get help.

http://us.battle.net/wow/en/forum/2626217/

You can also email
[api-support@blizzard.com](mailto:api-support@blizzard.com) for
matters that you may not want public discussion for.

### API Policy

With the continued popularity of third-party applications, which are
referred to hereafter as "applications" or "web applications", created
by the community of players for use with our games, Blizzard
Entertainment has created formal guidelines for their design and
distribution. These guidelines have been put in place to ensure the
integrity of our games and to help promote an enjoyable gaming
environment for all of our players.

Thank you for reading these guidelines, and for helping Blizzard
Entertainment continue to deliver high-quality gameplay experiences.

#### Intended Audience

The Third-Party API Usage Policy is for developers developing
applications, where applications include distributed and
non-distributed products and services that at any point engage
Blizzard Entertainment Web API resources. Web API resources include
any data that can be accessed through HTTP requests to URLs on the
Battle.net website that begin with "/api".

Example applications include, but are not limited to:

* Client libraries
* Desktop applications
* Services and deamons such as websites and web services
* Scripts and non-compiled applications and utilities

Blizzard Entertainment reserves the right to change the location and
definition of what constitutes an application and Blizzard
Entertainment Web API resources at any time.

#### Service Availability Notice

Blizzard Entertainment makes no guarantee of the availability of any
data, functionality, or feature provided by or through the API. In
addition, Blizzard Entertainment may at any time revoke access to the
API or disable part or all of the API without any warning or notice.

Applications must abide by the following access guidelines.

The following guidelines have been put in place to ensure that all
users of an API will be able to access it:

* Applications may make up to a total of 10,000 unauthenticated
  requests per day.
* Applications may make up to a total of 50,000 authenticated requests
  per day.
* Applications may not use multiple forms of access, including making
  any combination of unauthenticated and authenticated requests or
  using multiple API keys, to make more requests than permitted by the
  guidelines above. Applications may not use other third-party
  services to make additional requests on their behalf.
* Applications may not sell, share, transfer, or distribute
  application access keys or tokens.

Applications may be classified, solely at Blizzard Entertainment's
discretion, to allow fewer or greater numbers of requests per
day. Blizzard Entertainment also reserves the right to revoke access
to the API completely and without warning.

#### Applications may not charge premiums for features that use the API.

"Premium" versions of applications offering additional for-pay
features are not permitted, nor can players be charged money to
download an application, charged for services related to the
application, or otherwise be required to offer some form of monetary
compensation to download or access an application when those features
use the API. Applications may not include interstitials soliciting
donations before features or functionality becomes available to the
player.

#### Applications must not negatively impact Blizzard Entertainment games, services, or other players.

Applications must perform no function which, in Blizzard
Entertainment's sole discretion, negatively impacts the performance of
Blizzard Entertainment games or services, or otherwise negatively
affects the game for other players.

#### Application code must be completely visible.

The programming code of an application must in no way be hidden or
obfuscated, and must be freely accessible to and viewable by the
general public.

#### Applications may not imply any association with Blizzard Entertainment.

Applications may not imply any association with, or endorsement by,
Blizzard Entertainment.

#### Applications must not contain offensive or objectionable material.

Blizzard Entertainment requires that applications contain no
offensive, obscene, or otherwise objectionable material, as determined
by Blizzard's sole discretion. Applications should contain only
content appropriate for the ESRB rating for the related game(s). For
example, World of Warcraft has been rated "T for Teen" by the ESRB,
and has received similar ratings from other ratings boards around the
world.

#### Blizzard trademarks, titles, or tradenames should not be used when naming an application.

Applications may not use names based on Blizzard's trademarks or taken
from Blizzard's products as the name, or part of the name, of the
application.

### License for Use

Applications that use Blizzard Entertainment intellectual property,
such as Blizzard Web API resources, require a license for that
use. Blizzard Entertainment may at its sole discretion request that
any application that uses its intellectual property be removed and no
longer distributed.

### Policy Compliance Notice

Blizzard Entertainment is committed to maintaining the integrity of
our games and services and to providing safe, fair, and fun gaming
environment for all of our players. As such, failure to abide by the
guidelines in this policy may result in measures up to and including
legal action, when necessary.

<style>.gist-data { max-height: 400px; overflow: auto; }</style>
