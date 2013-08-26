#encoding:utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)                                             
Session.create(title:'讲讲我们在国内的合作开发',speaker:'Wang Zhe',start: '2013-08-31 01:30:00 +0800',end:'2013-08-31 14:10:00 +0800',location:'ROOM 1',date:'2013-08-31',description:'顺丰HHT作为国内第一个以交付为中心的商业合作开发项目，已经经历了将近3-4个月的风雨。作为经历若干Account头一次的试水者，谈谈这次的合作项目的感想，以及未来我们需要做的努力。对国内项目感兴趣么？来听听吧。对咨询与合作开发有疑问么？来听听我们的搞法。对乙方主导甲方的项目感兴趣？来听听如何作方案，如何管理客户。')
Session.create(title:'CDP',speaker:'Apirl Johnson',start: '2013-08-31 02:20:00 +0800',end:'2013-08-31 15:00:00 +0800',location:'ROOM 1',date:'2013-08-31',description:'A session about CDP and one booth is required as a information centre to let China ThoughtWorkers get aware of CDP project.')
Session.create(title:'把顺丰变成Design Thinking的企业',speaker:'Xiong Zichuan',start: '2013-08-31 03:10:00 +0800',end:'2013-08-31 15:50:00 +0800',location:'ROOM 1',date:'2013-08-31',description:'我会讲述我们在顺丰的故事，从设计、业务、技术以及文化上我们都在做什么、有什么故事、有什么困难、有什么思考。借此谈论关于国内市场开拓的话题。希望顺丰成为我们自己的REA。')
Session.create(title:'Singapore office',speaker:'Karin Yvonne Verloop & Umar Saqaf Saifulla Akhter',start: '2013-08-31 04:00:00 +0800',end:'2013-08-31 16:40:00 +0800',location:'ROOM 1',date:'2013-08-31',description:' Update about the Singapore office, where we are at, what we learned and what the plans are for the future.')
Session.create(title:'打造办公室——非OP视角',speaker:'Zheng Ye',start: '2013-08-31 04:50:00 +0800',end:'2013-08-31 17:30:00 +0800',location:'ROOM 1',date:'2013-08-31',description:'你可知道：以“人才培养基地”著称的西安办公室，当年的窘境是“一大堆毕业生可能影响交付”；你可知道，2012年的成都办公室还是一个“沉闷”所在，2013年就成了“有创新，无底线，P123都很牛”的地方。作为西安成都两个办公室建设的参与者，我想分享一下从我——一个非Office Principle——的视角看到的一些东西，近几年办公室建设的一些心得，也许还会谈到非职权影响力。')
Session.create(title:'在交付项目中做咨询',speaker:'Yao Yao',start: '2013-08-31 01:30:00 +0800',end:'2013-08-31 14:10:00 +0800',location:'ROOM 2',date:'2013-08-31',description:'咨询并不神秘，名正言顺的顶着咨询帽子为客户系统性地从策略到架构到实施解决问题固然风光无限，但是在交付项目中与客户团队进行合作软件开发时，也可以存在很多有实无名的咨询机会，从组织架构、交付方式、技术选型、团队成长等各个方面，为客户由小到大得解决问题。我将用自己在客户现场做交付的3个月经历，和大家分享如何用咨询的眼光做交付的经验和教训。')
Session.create(title:'Australian culture',speaker:'Amanda Ting',start: '2013-08-31 02:20:00 +0800',end:'2013-08-31 15:00:00 +0800',location:'ROOM 2',date:'2013-08-31',description:'If you haven\'t been to (or have been and want to know more about) the Land of the Big Hopping Rabbits (kangaroos), this is an opportunity for you to find out more about the Land "Down Under", Australia. Join your Aussie mates, Julian and Amanda in a fun, interactive session about what to expect and the unexpected, survival tips on how to quickly bridge the cultural gap, having fun on a very low to null budget, learn some Aussie slang and lots more.Or just come and grab some Aussie goodies!')
Session.create(title:'怎样黑掉邻家妹子的路由器',speaker:'Ma Wei',start: '2013-08-31 03:10:00 +0800',end:'2013-08-31 15:50:00 +0800',location:'ROOM 2',date:'2013-08-31',description:'标题有点唬人，见谅见谅，主要是介绍日常生活中容易被忽视的网络安全问题，形式将以实战攻防为主，欢迎各位来体验。')
Session.create(title:'Funny stories running (internal) startup',speaker:'Chen Jinzhou',start: '2013-08-31 04:00:00 +0800',end:'2013-08-31 16:40:00 +0800',location:'ROOM 2',date:'2013-08-31',description:'The product team has been running 18 months - for the product XingYii and Jinshuju. More than 10,000 people have benefit from our products. There are a lot of funny stories happened. I will share these stories - covering design, operation and business.')
Session.create(title:'面向中小型Rails项目全面技术栈',speaker:'Fu Ying & Jiang Peng & Wang Yan',start: '2013-08-31 04:50:00 +0800',end:'2013-08-31 17:30:00 +0800',location:'ROOM 2',date:'2013-08-31',description:'我们参与过REA的Reporting\Diamond这些应用Rails非常成熟的项目，也从头构建产品团队的“行易”和“金数据”两个产品，我们发现Rails已经成为中小型项目的技术首选。我们想谈一谈从敲下第一行的代码到项目的部署上线中所要遇到的Rails技术栈，例如注册/登陆、文件上传、Report、图片处理、支付、邮件、Mobile、API、Performance、监控和部署等等。这些也许是你现在或未来所遇到的，在这里你可以了解来自产品组的分享。')
Session.create(title:'Enterprise REST at Scale',speaker:'Brandon Byars',start: '2013-08-31 01:30:00 +0800',end:'2013-08-31 14:10:00 +0800',location:'ROOM 3',date:'2013-08-31',description:'Most internal REST APIs are one-off APIs purpose built for a single integration point.  I helped lead a very large legacy mainframe replacement which used REST as the integration strategy for the new system.  I\'ll discuss the constraints and flexibility that you have with non-public APIs, and lessons learned from doing large scale RESTful integration across more than a dozen teams.  My belief is that media types and hypermedia have much less to do with success than build and deploy infrastructure, testing strategies, understanding versioning, and bounded contexts.')
Session.create(title:'What is Innovation?',speaker:'Sam Newman',start: '2013-08-31 02:20:00 +0800',end:'2013-08-31 15:00:00 +0800',location:'ROOM 3',date:'2013-08-31',description:'We all seem to think we know when we see something that is Innovative, but try describing it, and we\'ll get about 100 different answers. This session looks at examples across ThoughtWorks of things we all would think of as Innovation, and will attempt to come up with a description that makes sense for us.')
Session.create(title:'见微知著——从客户的云策略演变看行业风向',speaker:'Ma Qiang',start: '2013-08-31 03:10:00 +0800',end:'2013-08-31 15:50:00 +0800',location:'ROOM 3',date:'2013-08-31',description:'我们的客户作为AWS的先锋（pioneer）用户，在云计算应用方面一直走在同行业的前列。作为合作伙伴，几年来，我们同客户一起参与了整个过程。未来两年，跟客户一起，我们还有更加aggressive的计划。同时我们认为，这也是行业的方向。乐意跟大家分享一下，客户的云策略演变，行业的趋势和我们想要努力站上的位置。')
Session.create(title:'Agile Kaleidescope - mirros and patterns',speaker:'Mark Coster',start: '2013-08-31 04:00:00 +0800',end:'2013-08-31 16:40:00 +0800',location:'ROOM 3',date:'2013-08-31',description:'Agile is a broad landscape of methodologies, principles, practices and tools. Kaleidescope - mirrors and patterns explores this rich tapestry - the themes of how practices are used, the broad differences and variation and how teams go through adoption and evolution. The common strand is what practices you chose, how you adapt yourself, your team and organisation to this disruptive change, but crucially how you adapt the practices over time as the team and organisation evolves. ')
Session.create(title:'ThoughtWorks University in my eyes -- From a trainer\'s perspective',speaker:'Zhang Yue & Derek Hammer',start: '2013-08-31 04:50:00 +0800',end:'2013-08-31 17:30:00 +0800',location:'ROOM 3' , date:'2013-08-31',description:'We want to share something about TWU as follows: (1) Open the mysterious veil of TWU (2) How to be a TWU trainer (3) What we did as a trainer (4) Suggestions for being a better trainer (5) Those funny and interesting moments in TWU 31 & TWU 32.')
Session.create(title:'设计师怎样帮BA把孩子养大', speaker:'Zhu Chen',start: '2013-08-31 01:30:00 +0800',end:'2013-08-31 14:10:00 +0800',location:'ROOM 4',date:'2013-08-31',description:'创业总会起源一个点子，但创业团队的高死亡率也暗示着这些点子往往都不靠谱。设计师该如何确保在不靠谱的根基上建房子，和BA、DEV、QA们一起在迷茫中探索呢？金数据的成长经历给了我们一些启发，很想和大家分享。')
Session.create(title:'Agile User Experience Design @ ThoughtWorks',speaker:'Nancy Chu',start: '2013-08-31 02:20:00 +0800',end:'2013-08-31 15:00:00 +0800',location:'ROOM 4',date:'2013-08-31',description:'Examples of User Experience Design Processes from various ThoughtWorks projects in North America and Australia/China and what kinds of skillsets are needed for each type of project.')
Session.create(title:'Mindfulness - Google\'s Secret Weapon for Career Success',speaker:'Patrick B. Sarnacke',start: '2013-08-31 03:10:00 +0800',end:'2013-08-31 15:50:00 +0800',location:'ROOM 4',date:'2013-08-31',description:'Google engineers are well known for being smart, logical thinkers. So what do they do to ensure happiness and career success? They meditate! Google employee #107, Chade-Meng Tan, has put together an internal training course that trains Googlers on attention, self-knowledge, and self-mastery. I\'ll talk about some of the science behind meditation and mindfulness, and we\'ll practice one or two of the exercises to start everyone on the path to happiness and success.')
Session.create(title:'把知识发表出来',speaker:'Hu Kai',start: '2013-08-31 04:00:00 +0800',end:'2013-08-31 16:40:00 +0800',location:'ROOM 4',date:'2013-08-31',description:'我自己已经发表了8篇文章，同时我帮助西安办公室的多位同事在今年发表了文章，我想分享一下整理知识的为什么和怎么办，最后，我会尝试用一个框架帮助大家来练习一下。')
Session.create(title:'Securing the Human Interface',speaker:'Joanne Moleskey &  Jean Zheng',start: '2013-08-31 04:50:00 +0800',end:'2013-08-31 17:30:00 +0800',location:'ROOM 4',date:'2013-08-31',description:'ThoughtWorks has embarked on a journey to increase the awareness of information security in all of our day to day activities. We are working behind the scenes to improve our technical capabilities in protecting systems and infrastructure, but our success in this area is dependant on every ThoughtWorker making responsible choices in this area everyday.Jean Zheng and Joanne Molesky from the global InfoSec team will lead this session on information Security. It will be mostly discussion with lots of time for questions and answers.Why do we need policies? What do you need to do to make ThoughtWork more aware of information security issues? Where can you get help with information Security?')
Session.create(title:'国内咨询的现状、问题及未来',speaker:'Huang Liang',start: '2013-08-31 01:30:00 +0800',end:'2013-08-31 14:10:00 +0800',location:'ROOM 5',date:'2013-08-31',description:'在中国，TW咨询业务已经有多年的历史，我们的团队由原来的几个人，扩展到现在的十几个人，我们给客户提供的内容也从小范围的敏捷，扩展到了包括持续交付、体验设计等更多的内容。在新的市场环境和内部环境下，国内的咨询团队有了新的变化，我们的服务策略也有了新的变化。这次的session将和大家分享这几个月来我们在咨询业务线上的一些思考，以及将来的发展方向。')
Session.create(title:'逻辑式编程与Prolog语言',speaker:'Han Kai',start: '2013-08-31 02:20:00 +0800',end:'2013-08-31 15:00:00 +0800',location:'ROOM 5',date:'2013-08-31',description:'逻辑式编程是声明式编程范式的一个分支。比起函数式近年来的复苏，逻辑式编程一直在学术界、工业界保持低调的姿态。但是这不阻碍它拥有大量的拥趸，比如Erlang的创始者Joe。Prolog是逻辑式编程世界中最有影响力的语言，它具有极简的语法和强大的表述能力，这得益于它背后的基础－一阶逻辑谓词。Joe曾经用200左右的Prolog代码实现了第一版本的Erlang！在这个Session里，我将带大家一起领略逻辑式编程与Prolog的风采。')
Session.create(title:'咨询师上手指南',speaker:'Zhang Kaifeng',start: '2013-08-31 03:10:00 +0800',end:'2013-08-31 15:50:00 +0800',location:'ROOM 5',date:'2013-08-31',description:'希望这个主题能够给从未在客户现场工作过是，在客户现场不知所措是，以及对客户现场工作充满无限遐想的同事们一点介绍和指导。')
Session.create(title:'Language-The often funny and bizarre ways in which we communicate',speaker:'Ronaldo Ferraz',start: '2013-08-31 04:00:00 +0800',end:'2013-08-31 16:40:00 +0800',location:'ROOM 5',date:'2013-08-31',description:'A look at how at how natural languages differ in the way they express concepts and how they impose some patterns on their speakers--and why it matters for cross-cultural communication. For that, we\'re going to explore the way talking about colors evolved in languages, how an Amazon tribe uses truth information in daily speech, and how people in general talk about gender.')
Session.create(title:'An insight into ThoughtWorks Africa',speaker:'Matthew Kasekende & Tholang Khoaene',start: '2013-08-31 04:50:00 +0800',end:'2013-08-31 17:30:00 +0800',location:'ROOM 5',date:'2013-08-31',description:'An interactive session where you will get an insight into what event & projects ThoughtWorks Africa has been involved in this year.')