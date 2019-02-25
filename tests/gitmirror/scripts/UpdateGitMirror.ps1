[CmdletBinding()]
Param(
    [string]$Destination,
    [switch]$CloneOnly,
    [switch]$PullOnly,
    [string[]]$Filter
)
# Use secure channel
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
if (-not $Destination.EndsWith('\') -and -not $Destination.EndsWith('/')) {
    $Destination += '/'
}
if([string]::IsNullOrEmpty($env:GITLAB_TOKEN)){
    Write-Error "No gitlab token! Stopping" -ErrorAction:Stop
}
if([string]::IsNullOrEmpty($env:GITHUB_TOKEN)){
    Write-Error "No gitlab token! Stopping" -ErrorAction:Stop
}
class GH {
    [string]$Name
    [bool]$HighVolume
    [string[]]$ExcludedSubmodules
    GH([string]$Name) {
        $this.Name = $Name
    }
    [GH]High() {
        $this.HighVolume = $true
        return $this
    }
    [GH]ExcludeSubModules([string[]]$modules) {
        $this.ExcludedSubmodules = $modules
        return $this
    }
}
Class RepoList {
    [GH[]]$GitHubOrgs
    [GH[]]$GitHubUsers
    [GH[]]$GitLabOrgs
    [GH[]]$GitLabUsers
}
$repos = [RepoList]::new()
$repos.GitHubOrgs = @(
    #region Watched Organizations
    [GH]::new('apple').High()
    [GH]::new('golang').High()
    [GH]::new('Shopify')
    [GH]::new('caddyserver').High()
    [GH]::new('git').High()
    [GH]::new('Microsoft').High()
    [GH]::new('aspnet').High()
    [GH]::new('python').High()
    [GH]::new('docker').High()
    [GH]::new('duplicati').High()
    [GH]::new('digitalocean').High()
    [GH]::new('PowerShell').High()
    [GH]::new('Azure').High()
    [GH]::new('vuejs').High()
    [GH]::new('restic').High()
    [GH]::new('influxdata').High()
    [GH]::new('ArchiveTeam').High()
    [GH]::new('rtfd').High()
    [GH]::new('jgraph').High()
    [GH]::new('atom').High()
    [GH]::new('google').High()
    [GH]::new('google-ar').High()
    [GH]::new('gohugoio').High()
    [GH]::new('googlechrome').High()
    [GH]::new('dotnet').High()
    [GH]::new('tensorflow').High()
    [GH]::new('rocketchat')
    [GH]::new('rust-lang').High()
    [GH]::new('reactjs').High()
    [GH]::new('pest-parser').High()
    [GH]::new('alexa').High()
    [GH]::new('uber').High()
    [GH]::new('git-lfs').High()
    [GH]::new('Homebrew').High()
    [GH]::new('Linuxbrew').High()
    [GH]::new('kubernetes').High()
    [GH]::new('cloudfoundry').High()
    [GH]::new('go-hep').High()
    [GH]::new('coreos').High()
    [GH]::new('drone-plugins').High()
    [GH]::new('snapcore').High()
    [GH]::new('goposse')
    [GH]::new('CrunchyData').High()
    [GH]::new('kubernetes-incubator').High()
    [GH]::new('moby').High()
    [GH]::new('aws').High()
    [GH]::new('apache').High()
    [GH]::new('g0v-data').High()
    [GH]::new('square').High()
    [GH]::new('stripe').High()
    [GH]::new('awslabs').High()
    [GH]::new('minio').High()
    [GH]::new('OpenMined').High()
    [GH]::new('cdnjs').High()
    [GH]::new('googlecreativelab').High()
    [GH]::new('gomatcha').High()
    [GH]::new('fnproject').High()
    [GH]::new('PAIR-code').High()
    [GH]::new('freeCodeCamp').High()
    [GH]::new('angular').High()
    [GH]::new('airbnb').High()
    [GH]::new('github').High()
    [GH]::new('d3').High()
    [GH]::new('twbs').High()
    [GH]::new('probot').High()
    [GH]::new('mozilla').High()
    [GH]::new('twitter').High()
    [GH]::new('thoughtbot').High()
    [GH]::new('Netflix').High()
    [GH]::new('facebook').High()
    [GH]::new('googlesamples').High()
    [GH]::new('h5bp').High()
    [GH]::new('iojs').High()
    [GH]::new('EbookFoundation').High()
    [GH]::new('jquery').High()
    [GH]::new('shadowsocks').High()
    [GH]::new('Tencent').High()
    [GH]::new('elastic').High()
    [GH]::new('ReactiveX').High()
    [GH]::new('HubSpot').High()
    [GH]::new('rails').High()
    [GH]::new('spring-projects').High()
    [GH]::new('Automattic').High()
    [GH]::new('Yalantis').High()
    [GH]::new('laravel').High()
    [GH]::new('driftyco').High()
    [GH]::new('facebookarchive').High()
    [GH]::new('yahoo').High()
    [GH]::new('electron').High()
    [GH]::new('zeit').High()
    [GH]::new('hashicorp').High()
    [GH]::new('expressjs').High()
    [GH]::new('FortAwesome').High()
    [GH]::new('angular-ui').High()
    [GH]::new('socketio').High()
    [GH]::new('facebookincubator').High()
    [GH]::new('FormidableLabs').High()
    [GH]::new('codrops').High()
    [GH]::new('zurb').High()
    [GH]::new('pallets').High()
    [GH]::new('openstack').High()
    [GH]::new('Semantic-Org').High()
    [GH]::new('webpack').High()
    [GH]::new('6to5').High()
    [GH]::new('meteor').High()
    [GH]::new('segmentio').High()
    [GH]::new('Ramotion').High()
    [GH]::new('JetBrains').High()
    [GH]::new('linkedin').High()
    [GH]::new('mongodb').High()
    [GH]::new('visionmedia').High()
    [GH]::new('ElemeFE').High()
    [GH]::new('firebase').High()
    [GH]::new('jekyll').High()
    [GH]::new('Bilibili').High()
    [GH]::new('getlantern').High()
    [GH]::new('realm').High()
    [GH]::new('spotify').High()
    [GH]::new('postcss').High()
    [GH]::new('dropbox').High()
    [GH]::new('mapbox')
    [GH]::new('moment')
    [GH]::new('ansible').High()
    [GH]::new('AFNetworking')
    [GH]::new('ecomfe')
    [GH]::new('etsy')
    [GH]::new('yeoman')
    [GH]::new('facebookresearch').High()
    [GH]::new('nwjs').High()
    [GH]::new('jenkinsci').High()
    [GH]::new('django')
    [GH]::new('chartjs')
    [GH]::new('impress').High()
    [GH]::new('adobe').High()
    [GH]::new('resume').High()
    [GH]::new('filamentgroup')
    [GH]::new('travis-ci').High()
    [GH]::new('alvarcarto')
    [GH]::new('GoogleCloudPlatform').High()
    [GH]::new('OpenRCT2')
    [GH]::new('OpenGenus').High()
    [GH]::new('GNOME').High()
    [GH]::new('curl').High()
    [GH]::new('MinecraftForge').High()
    [GH]::new('alibaba')
    [GH]::new('metabase').High()
    [GH]::new('discourse').High()
    [GH]::new('JuliaLang').High()
    # gov stuff from https://github.com/collections/government
    [GH]::new('GSA').High()
    [GH]::new('nasa').High()
    [GH]::new('18F').High()
    [GH]::new('cfpb').High()
    [GH]::new('alphagov').High()
    [GH]::new('codeforamerica').High()
    [GH]::new('project-open-data').High()
    [GH]::new('opengovfoundation').High()
    [GH]::new('ngageoint').High()
    [GH]::new('wet-boew').High()
    [GH]::new('CityOfPhiladelphia').High()
    [GH]::new('nysenate').High()
    [GH]::new('codeforboston').High()
    [GH]::new('openlexington').High()
    [GH]::new('uscensusbureau').High()
    [GH]::new('NREL').High()
    [GH]::new('usds').High()
    [GH]::new('republique-et-canton-de-geneve').High()
    # end gov stuff
    [GH]::new('MonoGame').High()
    [GH]::new('mono').High()
    [GH]::new('openaddresses').High()
    [GH]::new('mysql').High()
    [GH]::new('GoogleTrends').High()
    [GH]::new('nationalparkservice').High()
    [GH]::new('fivethirtyeight').High()
    [GH]::new('src-d').High()
    [GH]::new('openai').High()
    [GH]::new('deepmind').High()
    [GH]::new('iview').High()
    [GH]::new('fastify').High()
    [GH]::new('home-assistant').High()
    # Cloud Native Computing Foundation (CNCF) projects
    # https://www.cncf.io/projects/
    [GH]::new('prometheus').High()
    [GH]::new('opentracing').High()
    [GH]::new('fluent').High()
    [GH]::new('linkerd').High()
    [GH]::new('grpc').High()
    [GH]::new('coredns').High()
    [GH]::new('containerd').High()
    [GH]::new('rkt').High()
    [GH]::new('containernetworking').High()
    [GH]::new('envoyproxy').High()
    [GH]::new('jaegertracing').High()
    [GH]::new('theupdateframework').High()
    # end cncf
    [GH]::new('go-ego').High()
    [GH]::new('nodejs').High()
    [GH]::new('clearcontainers').High()
    [GH]::new('dutchcoders')
    [GH]::new('v8').High()
    [GH]::new('gwtproject').High()
    [GH]::new('CloudflareApps').High()
    [GH]::new('eclipse').High()
    [GH]::new('FreeCAD')
    [GH]::new('Gnucash')
    [GH]::new('xbmc')
    [GH]::new('MyCollab')
    [GH]::new('openaps')
    [GH]::new('opentoonz')
    [GH]::new('roundcube')
    [GH]::new('systemd')
    [GH]::new('ubuntu').High()
    [GH]::new('reactos').High()
    [GH]::new('gulpjs').High()
    [GH]::new('Polymer').High()
    [GH]::new('ReactTraining').High()
    [GH]::new('ethereum').High()
    [GH]::new('plataformatec').High()
    [GH]::new('thephpleague').High()
    [GH]::new('callemall')
    [GH]::new('requests')
    [GH]::new('inboxapp').High()
    [GH]::new('Flipboard').High()
    [GH]::new('gruntjs').High()
    [GH]::new('open-source-society')
    [GH]::new('Alamofire')
    [GH]::new('koajs')
    [GH]::new('spatie')
    [GH]::new('scrapy')
    [GH]::new('rethinkdb')
    [GH]::new('lodash')
    [GH]::new('yarnpkg')
    [GH]::new('swagger-api').High()
    [GH]::new('parse-community')
    [GH]::new('tastejs').High()
    [GH]::new('fex-team')
    [GH]::new('futurice')
    [GH]::new('emberjs').High()
    [GH]::new('TryGhost').High()
    [GH]::new('symfony')
    [GH]::new('clojure').High()
    [GH]::new('Masonry')
    [GH]::new('balderdashy').High()
    [GH]::new('heroku').High()
    [GH]::new('raywenderlich')
    [GH]::new('neovim').High()
    [GH]::new('firehol')
    [GH]::new('papers-we-love')
    [GH]::new('usablica')
    [GH]::new('basecamp').High()
    [GH]::new('udacity').High()
    [GH]::new('Leaflet')
    [GH]::new('serverless')
    [GH]::new('kriasoft')
    [GH]::new('getsentry')
    [GH]::new('ant-design')
    [GH]::new('ReactiveCocoa')
    [GH]::new('adafruit')
    [GH]::new('Reactive-Extensions')
    [GH]::new('harvesthq')
    [GH]::new('gitlabhq')
    [GH]::new('GitbookIO').High()
    [GH]::new('codepath')
    [GH]::new('hapijs').High()
    [GH]::new('Khan')
    [GH]::new('adobe-fonts')
    [GH]::new('NYTimes')
    [GH]::new('openresty')
    [GH]::new('webtorrent')
    [GH]::new('IronSummitMedia')
    [GH]::new('npm').High()
    [GH]::new('CyanogenMod')
    [GH]::new('Modernizr')
    [GH]::new('select2')
    [GH]::new('cocos2d')
    [GH]::new('marmelab')
    [GH]::new('railsware')
    [GH]::new('tc39')
    [GH]::new('AlloyTeam')
    [GH]::new('gogits')
    [GH]::new('metafizzy')
    [GH]::new('scikit-learn')
    [GH]::new('akveo')
    [GH]::new('Mashape')
    [GH]::new('xmartlabs')
    [GH]::new('videojs')
    [GH]::new('auth0')
    [GH]::new('sass')
    [GH]::new('BVLC')
    [GH]::new('browserify').High()
    [GH]::new('hexojs')
    [GH]::new('paypal').High()
    [GH]::new('fastlane')
    [GH]::new('yiisoft')
    [GH]::new('pld-linux')
    [GH]::new('Yelp')
    [GH]::new('Hack-with-Github')
    [GH]::new('bumptech')
    [GH]::new('certbot')
    [GH]::new('AngularClass').High()
    [GH]::new('requirejs').High()
    [GH]::new('request').High()
    [GH]::new('hyperoslo')
    [GH]::new('syncthing')
    [GH]::new('CocoaPods').High()
    [GH]::new('influxdb')
    [GH]::new('phonegap')
    [GH]::new('wix')
    [GH]::new('grafana')
    [GH]::new('ftlabs')
    [GH]::new('w3c')
    [GH]::new('reddit')
    [GH]::new('dmlc')
    [GH]::new('WhisperSystems').High()
    [GH]::new('open-guides')
    [GH]::new('android-cn').High()
    [GH]::new('bitcoin').High()
    [GH]::new('FreeCodeCampChina').High()
    [GH]::new('ipfs').High()
    [GH]::new('hammerjs').High()
    [GH]::new('ajaxorg')
    [GH]::new('powerline').High()
    [GH]::new('strongloop')
    [GH]::new('less')
    [GH]::new('FallibleInc')
    [GH]::new('huginn')
    [GH]::new('jadejs')
    [GH]::new('VerbalExpressions')
    [GH]::new('pixijs')
    [GH]::new('puppetlabs')
    [GH]::new('XX-net')
    [GH]::new('prettier')
    [GH]::new('xamarin')
    [GH]::new('SwiftyJSON').High()
    [GH]::new('mobxjs')
    [GH]::new('cloudflare')
    [GH]::new('bcit-ci')
    [GH]::new('chef')
    [GH]::new('roots')
    [GH]::new('ruby').High()
    [GH]::new('forkingdog')
    [GH]::new('infinitered')
    [GH]::new('android')
    [GH]::new('graphql')
    [GH]::new('libgdx')
    [GH]::new('php').High()
    [GH]::new('ValveSoftware').High()
    [GH]::new('bower').High()
    [GH]::new('interagent')
    [GH]::new('phusion')
    [GH]::new('VundleVim')
    [GH]::new('dokku')
    [GH]::new('StackExchange').High()
    [GH]::new('rancherio')
    [GH]::new('Qihoo360')
    [GH]::new('react-boilerplate').High()
    [GH]::new('palantir')
    [GH]::new('phalcon')
    [GH]::new('zxing')
    [GH]::new('rstudio')
    [GH]::new('playframework')
    [GH]::new('quilljs')
    [GH]::new('FriendsOfPHP')
    [GH]::new('NativeScript')
    [GH]::new('standard')
    [GH]::new('id-Software')
    [GH]::new('isocpp')
    [GH]::new('designmodo')
    [GH]::new('rapid7')
    [GH]::new('jasmine')
    [GH]::new('zeromq')
    [GH]::new('you-dont-need')
    [GH]::new('IFTTT')
    [GH]::new('textmate')
    [GH]::new('zsh-users')
    [GH]::new('storybooks')
    [GH]::new('pinterest')
    [GH]::new('styled-components')
    [GH]::new('limetext')
    [GH]::new('sequelize')
    [GH]::new('tornadoweb')
    [GH]::new('cakephp')
    [GH]::new('CreateJS')
    [GH]::new('tesseract-ocr')
    [GH]::new('ipython')
    [GH]::new('kivy')
    [GH]::new('senchalabs')
    [GH]::new('vmware')
    [GH]::new('plotly')
    [GH]::new('PHPOffice')
    [GH]::new('amazeui').High()
    [GH]::new('adobe-webplatform').High()
    [GH]::new('rbenv')
    [GH]::new('tumblr').High()
    [GH]::new('Kotlin').High()
    [GH]::new('aurelia')
    [GH]::new('kickstarter')
    [GH]::new('composer')
    [GH]::new('libgit2')
    [GH]::new('01org')
    [GH]::new('vapor')
    [GH]::new('servo').High()
    [GH]::new('DefinitelyTyped').High()
    [GH]::new('hubotio')
    [GH]::new('cheeriojs')
    [GH]::new('PerfectlySoft')
    [GH]::new('mochajs')
    [GH]::new('collectiveidea')
    [GH]::new('gliderlabs')
    [GH]::new('NetEase')
    [GH]::new('mutualmobile')
    [GH]::new('gatsbyjs')
    [GH]::new('riot')
    [GH]::new('scala')
    [GH]::new('capistrano')
    [GH]::new('cucumber')
    [GH]::new('codemirror').High()
    [GH]::new('karma-runner').High()
    [GH]::new('mailgun').High()
    [GH]::new('sinatra')
    [GH]::new('react-bootstrap')
    [GH]::new('pingcap')
    [GH]::new('caskroom')
    [GH]::new('MostlyAdequate')
    [GH]::new('elixir-lang')
    [GH]::new('geekcompany')
    [GH]::new('pypa')
    [GH]::new('GoThinkster')
    [GH]::new('WordPress')
    [GH]::new('algolia')
    [GH]::new('basho')
    [GH]::new('guardian')
    [GH]::new('venmo')
    [GH]::new('phacility')
    [GH]::new('keystonejs')
    [GH]::new('drone')
    [GH]::new('node-inspector')
    [GH]::new('douban')
    [GH]::new('naptha')
    [GH]::new('joyent').High()
    [GH]::new('avajs')
    [GH]::new('fbsamples')
    [GH]::new('oneuijs')
    [GH]::new('tmux-plugins')
    [GH]::new('reactnativecn')
    [GH]::new('keen')
    [GH]::new('jupyter')
    [GH]::new('raspberrypi')
    [GH]::new('yandex')
    [GH]::new('gin-gonic')
    [GH]::new('zendframework')
    [GH]::new('pandas-dev')
    [GH]::new('processing')
    [GH]::new('rollup')
    [GH]::new('guard')
    [GH]::new('flatiron')
    [GH]::new('graphcool')
    [GH]::new('RailsApps')
    [GH]::new('css-modules').High()
    [GH]::new('amfe')
    [GH]::new('nodejitsu')
    [GH]::new('torch')
    [GH]::new('gorilla').High()
    [GH]::new('infernojs')
    [GH]::new('owncloud').High()
    [GH]::new('diaspora')
    [GH]::new('Esri')
    [GH]::new('doctrine')
    [GH]::new('cockroachdb')
    [GH]::new('encode')
    [GH]::new('ampproject')
    [GH]::new('phoenixframework')
    [GH]::new('cmderdev')
    [GH]::new('dropwizard')
    [GH]::new('wekan')
    [GH]::new('OfficeDev')
    [GH]::new('netty')
    [GH]::new('saltstack')
    [GH]::new('scotch-io')
    [GH]::new('pagekit')
    [GH]::new('foreverjs')
    [GH]::new('WebAssembly')
    [GH]::new('exacity').High()
    [GH]::new('redox-os')
    [GH]::new('guzzle')
    [GH]::new('KnpLabs')
    [GH]::new('yabwe')
    [GH]::new('hybridgroup')
    [GH]::new('youtube')
    [GH]::new('git-tips')
    [GH]::new('pyenv')
    [GH]::new('mybatis')
    [GH]::new('tootsuite')
    [GH]::new('activeadmin')
    [GH]::new('pytorch')
    [GH]::new('docker-library').High()
    [GH]::new('Famous')
    [GH]::new('BrowserSync').High()
    [GH]::new('Mantle')
    [GH]::new('NUKnightLab')
    [GH]::new('Jam3')
    [GH]::new('xitu')
    [GH]::new('CodeHubApp')
    [GH]::new('apiaryio')
    [GH]::new('magicalpanda')
    [GH]::new('uikit')
    [GH]::new('linnovate')
    [GH]::new('LightTable')
    [GH]::new('nodemailer')
    [GH]::new('pouchdb')
    [GH]::new('celery')
    [GH]::new('php-fig')
    [GH]::new('rabbitmq')
    [GH]::new('Raizlabs')
    [GH]::new('piwik')
    [GH]::new('nomad')
    [GH]::new('browserstate')
    [GH]::new('Carthage')
    [GH]::new('twitter-archive')
    [GH]::new('wearehive')
    [GH]::new('GraphKit')
    [GH]::new('cujojs')
    [GH]::new('alcatraz')
    [GH]::new('cayleygraph')
    [GH]::new('ramda')
    [GH]::new('RestKit')
    [GH]::new('ruby-grape')
    [GH]::new('resque')
    [GH]::new('jhipster')
    [GH]::new('tldr-pages')
    [GH]::new('scaleway').High()
    [GH]::new('vim')
    [GH]::new('yhat')
    [GH]::new('scrapinghub')
    [GH]::new('vim-airline')
    [GH]::new('eslint')
    [GH]::new('mysqljs')
    [GH]::new('selectize')
    [GH]::new('SVProgressHUD')
    [GH]::new('path')
    [GH]::new('sbt')
    [GH]::new('uxsolutions')
    [GH]::new('slimphp')
    [GH]::new('akka')
    [GH]::new('woothemes')
    [GH]::new('trailofbits')
    [GH]::new('localForage')
    [GH]::new('SheetJS')
    [GH]::new('flarum')
    [GH]::new('trailblazer')
    [GH]::new('SeleniumHQ')
    [GH]::new('deeplearning4j')
    [GH]::new('googlei18n')
    [GH]::new('redux-saga')
    [GH]::new('bitly')
    [GH]::new('elm-lang')
    [GH]::new('containous')
    [GH]::new('feathersjs')
    [GH]::new('crystal-lang')
    [GH]::new('spree')
    [GH]::new('mesosphere')
    [GH]::new('labstack')
    [GH]::new('FasterXML')
    [GH]::new('marionettejs')
    [GH]::new('godotengine')
    [GH]::new('sqlmapproject')
    [GH]::new('googlemaps')
    [GH]::new('cloudera')
    [GH]::new('go-martini')
    [GH]::new('BoltsFramework')
    [GH]::new('source-foundry')
    [GH]::new('dangdangdotcom')
    [GH]::new('vigetlabs')
    [GH]::new('enormego')
    [GH]::new('naver')
    [GH]::new('appium')
    [GH]::new('rails-api')
    [GH]::new('getpelican')
    [GH]::new('PHPMailer')
    [GH]::new('Quick')
    [GH]::new('handsontable')
    [GH]::new('boot2docker')
    [GH]::new('CocoaLumberjack')
    [GH]::new('oxford-cs-deepnlp-2017')
    [GH]::new('fullstackio')
    [GH]::new('mozilla-services')
    [GH]::new('soundcloud')
    [GH]::new('svg')
    [GH]::new('msgpack')
    [GH]::new('ServiceStack')
    [GH]::new('progit')
    [GH]::new('slackhq').High()
    [GH]::new('docopt')
    [GH]::new('systemjs').High()
    [GH]::new('zalando')
    [GH]::new('seatgeek')
    [GH]::new('fabric')
    [GH]::new('sourcegraph').High()
    [GH]::new('shieldfy')
    [GH]::new('grab')
    [GH]::new('winstonjs')
    [GH]::new('sdelements')
    [GH]::new('boto')
    [GH]::new('yui')
    [GH]::new('revel')
    [GH]::new('pockethub')
    [GH]::new('learn-anything')
    [GH]::new('tildeio')
    [GH]::new('cyclejs')
    [GH]::new('KhronosGroup')
    [GH]::new('mitmproxy')
    [GH]::new('jshint')
    [GH]::new('getgrav')
    [GH]::new('braziljs')
    [GH]::new('gollum').High()
    [GH]::new('rspec')
    [GH]::new('so-fancy')
    [GH]::new('breach')
    [GH]::new('localstack')
    [GH]::new('ternjs')
    [GH]::new('quantopian')
    [GH]::new('sparklemotion')
    [GH]::new('knockout')
    [GH]::new('mozilla-mobile')
    [GH]::new('arduino')
    [GH]::new('databricks')
    [GH]::new('Stylus')
    [GH]::new('Karumi')
    [GH]::new('uNetworking')
    [GH]::new('b3log')
    [GH]::new('Rochester-NRT')
    [GH]::new('krakenjs')
    [GH]::new('ribot')
    [GH]::new('NodeRedis')
    [GH]::new('react-native-training')
    [GH]::new('lyft')
    [GH]::new('vim-syntastic')
    [GH]::new('paperjs')
    [GH]::new('reactphp')
    [GH]::new('twilio')
    [GH]::new('FFmpeg')
    [GH]::new('OpenEmu')
    [GH]::new('NVIDIA')
    [GH]::new('realpython')
    [GH]::new('cmusatyalab')
    [GH]::new('MithrilJS')
    [GH]::new('BBC-News')
    [GH]::new('swoole')
    [GH]::new('dcloudio')
    [GH]::new('node-webot')
    [GH]::new('FriendsOfSymfony')
    [GH]::new('h2o')
    [GH]::new('fish-shell')
    [GH]::new('datasciencemasters')
    [GH]::new('Instagram')
    [GH]::new('teamcapybara')
    [GH]::new('purifycss')
    [GH]::new('cisco')
    [GH]::new('cesanta')
    [GH]::new('NodeBB')
    [GH]::new('carrierwaveuploader')
    [GH]::new('jquery-validation')
    [GH]::new('Masterminds')
    [GH]::new('bokeh')
    [GH]::new('FineUploader')
    [GH]::new('bazelbuild')
    [GH]::new('deis')
    [GH]::new('nccgroup')
    [GH]::new('xing')
    [GH]::new('couchbase')
    [GH]::new('EnterpriseQualityCoding')
    [GH]::new('seajs')
    [GH]::new('odoo')
    [GH]::new('junit-team')
    [GH]::new('ether')
    [GH]::new('openshift')
    [GH]::new('mesos')
    [GH]::new('Huddle')
    [GH]::new('Grouper')
    [GH]::new('KeepSafe')
    [GH]::new('TTTAttributedLabel')
    [GH]::new('pili-io')
    [GH]::new('tmux')
    [GH]::new('brunch')
    [GH]::new('appcelerator')
    [GH]::new('relax')
    [GH]::new('go-kit')
    [GH]::new('lingochamp')
    [GH]::new('icsharpcode')
    [GH]::new('ropensci')
    [GH]::new('Compass')
    [GH]::new('mindmup')
    [GH]::new('evernote')
    [GH]::new('TeamStuQ')
    [GH]::new('artsy')
    [GH]::new('qiniu')
    [GH]::new('nats-io')
    [GH]::new('NLPchina')
    [GH]::new('howdyai')
    [GH]::new('thx')
    [GH]::new('PistonDevelopers')
    [GH]::new('summernote')
    [GH]::new('activerecord-hackery')
    [GH]::new('carlhuda')
    [GH]::new('OWASP')
    [GH]::new('sparkfun')
    [GH]::new('esp8266')
    [GH]::new('weaveworks')
    [GH]::new('taigaio')
    [GH]::new('datproject')
    [GH]::new('CRYTEK')
    [GH]::new('CodeSeven')
    [GH]::new('libuv')
    [GH]::new('react-toolbox')
    [GH]::new('fullcalendar')
    [GH]::new('restify')
    [GH]::new('atech')
    [GH]::new('getredash')
    [GH]::new('OAI')
    [GH]::new('wikimedia')
    [GH]::new('divio')
    [GH]::new('brigade')
    [GH]::new('babun')
    [GH]::new('NaturalNode')
    [GH]::new('mailchimp')
    [GH]::new('SignalR')
    [GH]::new('gradle')
    [GH]::new('sockjs').High()
    [GH]::new('objcio')
    [GH]::new('reactide')
    [GH]::new('middleman')
    [GH]::new('c3js').High()
    [GH]::new('nightwatchjs')
    [GH]::new('facebookgo')
    [GH]::new('pinax')
    [GH]::new('emmetio')
    [GH]::new('mailpile')
    [GH]::new('EsotericSoftware')
    [GH]::new('mailcheck')
    [GH]::new('fsprojects')
    [GH]::new('erlang')
    [GH]::new('typesafehub')
    [GH]::new('minetest').High()
    [GH]::new('chocolatey')
    [GH]::new('umano')
    [GH]::new('js-cookie').High()
    [GH]::new('amzn').High()
    [GH]::new('react-component')
    [GH]::new('Theano')
    [GH]::new('SublimeText').High()
    [GH]::new('tutsplus')
    [GH]::new('cachethq')
    [GH]::new('Moya')
    [GH]::new('nlp-compromise')
    [GH]::new('tmuxinator')
    [GH]::new('yuantiku')
    [GH]::new('flightjs')
    [GH]::new('greensock')
    [GH]::new('boltdb')
    [GH]::new('zhihu')
    [GH]::new('shutterstock')
    [GH]::new('Mango')
    [GH]::new('stanfordnlp')
    [GH]::new('haiwen')
    [GH]::new('aio-libs')
    [GH]::new('apl-devs')
    [GH]::new('LMAX-Exchange')
    [GH]::new('casperjs').High()
    [GH]::new('jsdoc3')
    [GH]::new('Laverna')
    [GH]::new('trello')
    [GH]::new('git-up')
    [GH]::new('zulip')
    [GH]::new('exercism')
    [GH]::new('es-shims')
    [GH]::new('seattlerb')
    [GH]::new('sqlitebrowser')
    [GH]::new('prestodb')
    [GH]::new('micro')
    [GH]::new('flynn')
    [GH]::new('watson-developer-cloud')
    [GH]::new('matplotlib')
    [GH]::new('leancloud')
    [GH]::new('memcached')
    [GH]::new('documentcloud')
    [GH]::new('SpiderLabs')
    [GH]::new('elabs')
    [GH]::new('mail-in-a-box')
    [GH]::new('JikeXueyuanWiki')
    [GH]::new('liferay')
    [GH]::new('Stratio')
    [GH]::new('medialize')
    [GH]::new('fontello')
    [GH]::new('resin-io')
    [GH]::new('bitpay')
    [GH]::new('morrisjs')
    [GH]::new('Kozea')
    [GH]::new('cnodejs').High()
    [GH]::new('futuresimple')
    [GH]::new('mpv-player')
    [GH]::new('ducksboard')
    [GH]::new('bestiejs')
    [GH]::new('dingo')
    [GH]::new('graphite-project')
    [GH]::new('octobercms')
    [GH]::new('zeroclipboard')
    [GH]::new('shipyard')
    [GH]::new('numenta')
    [GH]::new('h2oai')
    [GH]::new('box')
    [GH]::new('stretchr')
    [GH]::new('ceph')
    [GH]::new('redis').High()
    [GH]::new('ShareX').High()
    [GH]::new('ShinobiControls')
    [GH]::new('openframeworks')
    [GH]::new('WhiteHouse')
    [GH]::new('magento')
    [GH]::new('peers')
    [GH]::new('chef-cookbooks')
    [GH]::new('toml-lang')
    [GH]::new('silexphp')
    [GH]::new('TelescopeJS')
    [GH]::new('hyperledger')
    [GH]::new('ninenines')
    [GH]::new('Haneke')
    [GH]::new('eBay').High()
    [GH]::new('novus')
    [GH]::new('coursera-dl')
    [GH]::new('HabitRPG')
    [GH]::new('celluloid')
    [GH]::new('almende')
    [GH]::new('codemix')
    [GH]::new('Hearst-DD')
    [GH]::new('Bearded-Hen')
    [GH]::new('SFTtech')
    [GH]::new('nodeca')
    [GH]::new('boostorg')
    [GH]::new('twostairs')
    [GH]::new('angular-app')
    [GH]::new('poole')
    [GH]::new('zendesk').High()
    [GH]::new('micropython')
    [GH]::new('MiCode')
    [GH]::new('edx')
    [GH]::new('typekit')
    [GH]::new('couchbaselabs')
    [GH]::new('gopherjs')
    [GH]::new('at-import')
    [GH]::new('antlr')
    [GH]::new('SublimeLinter')
    [GH]::new('WP-API')
    [GH]::new('pillarjs')
    [GH]::new('okfn')
    [GH]::new('guardianproject')
    [GH]::new('codecombat')
    [GH]::new('yixia')
    [GH]::new('CyberAgent')
    [GH]::new('octokit')
    [GH]::new('dollarshaveclub')
    [GH]::new('LearnBoost')
    [GH]::new('druid-io')
    [GH]::new('Intervention')
    [GH]::new('badoo')
    [GH]::new('netlify')
    [GH]::new('nfl')
    [GH]::new('openalpr')
    [GH]::new('telerik')
    [GH]::new('baconjs')
    [GH]::new('webcomponents')
    [GH]::new('reactioncommerce')
    [GH]::new('jscs-dev')
    [GH]::new('dc-js')
    [GH]::new('CatchChat')
    [GH]::new('wbkd')
    [GH]::new('locustio')
    [GH]::new('nginx')
    [GH]::new('puma')
    [GH]::new('processone')
    [GH]::new('overtone')
    [GH]::new('NancyFx')
    [GH]::new('eleme')
    [GH]::new('RisingStack')
    [GH]::new('component')
    [GH]::new('oracle')
    [GH]::new('slim-template')
    [GH]::new('derbyjs')
    [GH]::new('nltk')
    [GH]::new('puniverse')
    [GH]::new('clips')
    [GH]::new('BabylonJS')
    [GH]::new('Pylons')
    [GH]::new('wkhtmltopdf')
    [GH]::new('intridea')
    [GH]::new('popcorn-time')
    [GH]::new('FrontendMasters')
    [GH]::new('dart-lang')
    [GH]::new('Unity-Technologies')
    [GH]::new('ractivejs')
    [GH]::new('sensepost')
    [GH]::new('OnsenUI')
    [GH]::new('prolificinteractive')
    [GH]::new('ExactTarget')
    [GH]::new('walmartlabs')
    [GH]::new('mopidy')
    [GH]::new('openhab')
    [GH]::new('jquery-ui-bootstrap')
    [GH]::new('chaijs')
    [GH]::new('delight-im')
    [GH]::new('node-red')
    [GH]::new('Medium')
    [GH]::new('TeehanLax')
    [GH]::new('flot')
    [GH]::new('lotus')
    [GH]::new('pubnub')
    [GH]::new('keybase').High()
    [GH]::new('andyet')
    [GH]::new('Prismatic')
    [GH]::new('lisa-lab')
    [GH]::new('north')
    [GH]::new('phpredis')
    [GH]::new('spring-cloud')
    [GH]::new('pry')
    [GH]::new('ctfs')
    [GH]::new('crossbario')
    [GH]::new('showdownjs')
    [GH]::new('tictail')
    [GH]::new('sdc-alibaba')
    [GH]::new('arangodb')
    [GH]::new('citusdata')
    [GH]::new('confluentinc')
    [GH]::new('DevExpress')
    [GH]::new('avast')
    [GH]::new('layerhq')
    [GH]::new('Ranks')
    [GH]::new('wordpress-mobile')
    [GH]::new('componentjs')
    [GH]::new('freebsd')
    [GH]::new('synergy')
    [GH]::new('CartoDB')
    [GH]::new('snowplow')
    [GH]::new('draios')
    [GH]::new('applidium')
    [GH]::new('Quartz')
    [GH]::new('dataarts')
    [GH]::new('topcoat')
    [GH]::new('devbridge')
    [GH]::new('openssl')
    [GH]::new('thumbor')
    [GH]::new('Codeception')
    [GH]::new('badges')
    [GH]::new('boxen')
    [GH]::new('pusher')
    [GH]::new('Respect')
    [GH]::new('mockito')
    [GH]::new('novoda')
    [GH]::new('OptimalBits')
    [GH]::new('jruby')
    [GH]::new('TypeStrong')
    [GH]::new('postmanlabs')
    [GH]::new('bitstadium')
    [GH]::new('cookpad')
    [GH]::new('CanvasPod')
    [GH]::new('nim-lang')
    [GH]::new('bup')
    [GH]::new('willowtreeapps')
    [GH]::new('bloomberg')
    [GH]::new('500px')
    [GH]::new('madebymany')
    [GH]::new('kif-framework')
    [GH]::new('substance')
    [GH]::new('sitepoint-editors')
    [GH]::new('apidoc')
    [GH]::new('XVimProject')
    [GH]::new('bignerdranch')
    [GH]::new('PyCQA')
    [GH]::new('mathjax')
    [GH]::new('thinkpixellab')
    [GH]::new('numpy')
    [GH]::new('libretro')
    [GH]::new('thinkgem')
    [GH]::new('rvm')
    [GH]::new('taskrabbit')
    [GH]::new('neo4j')
    [GH]::new('fantasyland')
    [GH]::new('dianping')
    [GH]::new('lelylan')
    [GH]::new('ember-cli')
    [GH]::new('fastos')
    [GH]::new('moxiecode')
    [GH]::new('purescript')
    [GH]::new('vimeo')
    [GH]::new('USArmyResearchLab')
    [GH]::new('sensu')
    [GH]::new('mailru')
    [GH]::new('Blizzard')
    [GH]::new('bottlepy')
    [GH]::new('sharelatex')
    [GH]::new('AutoMapper')
    [GH]::new('duckduckgo')
    [GH]::new('NodeOS').High()
    [GH]::new('beautify-web')
    [GH]::new('sandstorm-io')
    [GH]::new('BBC').High()
    [GH]::new('GetStream')
    [GH]::new('real-logic')
    [GH]::new('openexchangerates')
    [GH]::new('Squirrel')
    [GH]::new('jpush')
    [GH]::new('appbaseio')
    [GH]::new('layervault')
    [GH]::new('rdash')
    [GH]::new('iron')
    [GH]::new('umdjs')
    [GH]::new('meanjs')
    [GH]::new('OpenRefine')
    [GH]::new('winjs')
    [GH]::new('TransitApp')
    [GH]::new('tools')
    [GH]::new('pivotal')
    [GH]::new('sinonjs')
    [GH]::new('MacGapProject')
    [GH]::new('arachnys')
    [GH]::new('intuit')
    [GH]::new('bytedeco')
    [GH]::new('fossasia')
    [GH]::new('prerender')
    [GH]::new('deployphp')
    [GH]::new('nette')
    [GH]::new('tinymce')
    [GH]::new('pattern-lab')
    [GH]::new('wit-ai')
    [GH]::new('thinkaurelius')
    [GH]::new('typelift')
    [GH]::new('amdjs')
    [GH]::new('oreillymedia')
    [GH]::new('webpy')
    [GH]::new('json-api')
    [GH]::new('googleanalytics')
    [GH]::new('gocardless')
    [GH]::new('disqus')
    [GH]::new('jOOQ')
    [GH]::new('Webschool-io')
    [GH]::new('MyCATApache')
    [GH]::new('allegro')
    [GH]::new('deployd')
    [GH]::new('Freeboard')
    [GH]::new('robolectric')
    [GH]::new('opal')
    [GH]::new('sympy')
    [GH]::new('newsapps')
    [GH]::new('densitydesign')
    [GH]::new('dockyard')
    [GH]::new('slap-editor')
    [GH]::new('squizlabs')
    [GH]::new('Mono-Game')
    [GH]::new('whatwg')
    [GH]::new('OpenRA')
    [GH]::new('NixOS')
    [GH]::new('asciinema')
    [GH]::new('SonarSource')
    [GH]::new('EFForg')
    [GH]::new('prose')
    [GH]::new('Aerolab')
    [GH]::new('HumbleSoftware')
    [GH]::new('datastax')
    [GH]::new('humanmade')
    [GH]::new('SublimeCodeIntel')
    [GH]::new('yapstudios')
    [GH]::new('openlayers')
    [GH]::new('editorconfig')
    [GH]::new('aspnetboilerplate')
    [GH]::new('suitcss')
    [GH]::new('spring-guides')
    [GH]::new('asciidoctor')
    [GH]::new('rendrjs')
    [GH]::new('OpenHFT')
    [GH]::new('720kb')
    [GH]::new('pybee')
    [GH]::new('openstack-infra').High()
    [GH]::new('newrelic')
    [GH]::new('telly')
    [GH]::new('remotestorage').High()
    [GH]::new('ipfs')
    [GH]::new('frappe')
    [GH]::new('videojs')
    [GH]::new('OpenRefine')
    #endregion Watched Organizations
) | Sort-Object {Get-Random}
# watch-gh / add-gh
$repos.GitHubUsers = @(
    #region Watched users
    [GH]::new('nvbn')
    [GH]::new('i0natan')
    [GH]::new('metrue')
    [GH]::new('jessfraz').High()
    [GH]::new('scheib').High()
    [GH]::new('chylex').High()
    [GH]::new('McJty').High()
    [GH]::new('abiosoft').High()
    [GH]::new('lundman').High()
    [GH]::new('learnbyexample').High()
    [GH]::new('cirosantilli').High()
    [GH]::new('tianon').High()
    [GH]::new('ryanburgess').High()
    [GH]::new('vinta').High()
    [GH]::new('Thibaut').High()
    [GH]::new('thedaviddias').High()
    [GH]::new('junegunn').High()
    [GH]::new('jtoy').High()
    [GH]::new('josephmisiti').High()
    [GH]::new('beamandrew').High()
    [GH]::new('jahands').High()
    [GH]::new('ncw').High()
    [GH]::new('mholt').High()
    [GH]::new('rg3').High()
    [GH]::new('BurntSushi').High()
    [GH]::new('beaston02').High()
    [GH]::new('shanalikhan').High()
    [GH]::new('monero-project').High()
    [GH]::new('nrw').High()
    [GH]::new('joshtronic').High()
    [GH]::new('0x13a').High()
    [GH]::new('vim-scripts').High()
    [GH]::new('derekparker').High()
    [GH]::new('gorhill').High()
    [GH]::new('ory').High()
    [GH]::new('zyedidia').High()
    [GH]::new('csurfer').High()
    [GH]::new('yangshun').High()
    [GH]::new('Darkosto').High()
    [GH]::new('mbeaudru').High()
    [GH]::new('sindresorhus').High()
    [GH]::new('JakeWharton').High()
    [GH]::new('torvalds').High()
    [GH]::new('tj').High()
    [GH]::new('getify').High()
    [GH]::new('Tyriar').High()
    [GH]::new('jashkenas').High()
    [GH]::new('donnemartin').High()
    [GH]::new('robbyrussell').High()
    [GH]::new('hakimel').High()
    [GH]::new('kennethreitz').High()
    [GH]::new('substack').High()
    [GH]::new('Property404').High()
    [GH]::new('sharkdp').High()
    [GH]::new('nozzle').High()
    [GH]::new('agermanidis').High()
    [GH]::new('akxcv').High()
    [GH]::new('vicky002').High()
    [GH]::new('raxod502').High()
    [GH]::new('sfackler').High()
    [GH]::new('rexdex').High()
    [GH]::new('andymccurdy').High()
    [GH]::new('exaile')
    #endregion Watched users
) | Sort-Object {Get-Random}

$repos.GitLabOrgs = @(
    [GH]::new('gitlab-com').High()
    [GH]::new('gitlab-org').High()
) | Sort-Object {Get-Random}

$repos.GitLabUsers = @(
    [GH]::new('jhands')
) | Sort-Object {Get-Random}

# Filters
if ($Filter) {
    $r = [RepoList]::new()
    foreach ($f in (@() + $Filter)) {
        $r.GitHubOrgs += $repos.GitHubOrgs | Where-Object {$_.Name.ToLower() -eq $f.ToLower()}
        $r.GitHubUsers += $repos.GitHubUsers | Where-Object {$_.Name.ToLower() -eq $f.ToLower()}
        $r.GitLabOrgs += $repos.GitLabOrgs | Where-Object {$_.Name.ToLower() -eq $f.ToLower()}
        $r.GitLabUsers += $repos.GitLabUsers | Where-Object {$_.Name.ToLower() -eq $f.ToLower()}
    }
    $repos = $r
}
# Utils
Function ParseNextLink([string]$Link) {
    if (-not $Link.Contains('rel="next')) {
        Return $null
    }
    Return $Link.Substring(1, $Link.IndexOf('>; rel="next"') - 1)
}
Function TryToUpdateRepo([string]$CloneUrl, [string]$Destination) {
    if (Test-Path $Destination) {
        if ($CloneOnly) {
            Write-Verbose "Skipping because already exists: $CloneUrl"
        } else {
            try {
                Write-Verbose "Trying to git pull $CloneUrl"
                Set-Location $Destination
                git pull
            } catch {
                Write-Verbose "Failed to pull. Re-cloning $CloneUrl"
                Remove-Item $Destination -Recurse -Force
                git clone $CloneUrl $Destination
                Start-Sleep -Seconds 3
            }
        }
    } elseif (-not $PullOnly) {
        Write-Verbose "Cloning for first time: $CloneUrl"
        git clone $CloneUrl $Destination
        Start-Sleep -Seconds 3
    }
}
# GitHub
$password = ConvertTo-SecureString $env:GITHUB_TOKEN -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('jahands', $password)
foreach ($org in ($repos.GitHubOrgs | Where-Object {$_.HighVolume}).Name) {
    $exclude = @(
        "yahoo/HLSprovider"
    )
    $nextUrl = "https://api.github.com/orgs/$org/repos?sort=created&direction=desc&per_page=200"
    do {
        $payload = (Invoke-WebRequest $nextUrl -Authentication Basic -Credential $cred)
        $repos = $payload.Content | ConvertFrom-Json
        # Update local copy
        foreach ($r in ($repos | Sort-Object {Get-Random} | Where-Object {-not $exclude.Contains($_.full_name)})) {
            $dest = "$($Destination)clone/github.com/orgs/$($r.full_name)"
            TryToUpdateRepo -CloneUrl $r.clone_url -Destination $dest
        }
        $nextUrl = (ParseNextLink $payload.Headers.Link)
        # Deal with ratelimiting
        if ($payload.Headers.'X-RateLimit-Remaining' -le 1) {
            Start-Sleep -Seconds (60 * 60)
        }
    }while ($nextUrl -ne $null)
}

foreach ($user in ($repos.GitHubUsers | Where-Object {$_.HighVolume}).Name) {
    $exclude = @()
    $nextUrl = "https://api.github.com/users/$user/repos?sort=created&direction=desc&per_page=200"
    do {
        $payload = (Invoke-WebRequest $nextUrl -Authentication Basic -Credential $cred)
        $repos = $payload.Content | ConvertFrom-Json
        # Update local copy
        foreach ($r in ($repos | Sort-Object {Get-Random} | Where-Object {-not $exclude.Contains($_.full_name)})) {
            $dest = "$($Destination)clone/github.com/users/$($r.full_name)"
            TryToUpdateRepo -CloneUrl $r.clone_url -Destination $dest
        }
        $nextUrl = (ParseNextLink $payload.Headers.Link)
        # Deal with ratelimiting
        if ($payload.Headers.'X-RateLimit-Remaining' -le 1) {
            Start-Sleep -Seconds (60 * 60)
        }
    }while ($nextUrl -ne $null)
}
# GitLab
foreach ($group in $repos.GitLabUsers.Name) {
    $exclude = @(
        'gitlab-com/organization'
        'gitlab-com/githost'
        'gitlab-org/end-user-admin'
        'gitlab-com/federal'
    )
    $repos = (Invoke-RestMethod "https://gitlab.com/api/v4/groups/$group/projects?private_token=$env:GITLAB_TOKEN&per_page=100") |
        Where-Object visibility -eq 'public'
    foreach ($r in ($repos | Sort-Object {Get-Random})) {
        if (-not $exclude.Contains($r.path_with_namespace)) {
            $dest = "$($Destination)clone/gitlab.com/orgs/$($r.path_with_namespace)"
            TryToUpdateRepo -CloneUrl $r.http_url_to_repo -Destination $dest
        }
    }
}
