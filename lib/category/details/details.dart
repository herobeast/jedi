import 'package:flutter/material.dart';
import 'package:jedi/category/details/blocks/product_exhibition_area.dart';
import 'package:jedi/category/details/blocks/sharing_and_collar.dart';
import 'package:jedi/category/details/blocks/product_details.dart';
import 'package:jedi/category/details/blocks/recommend_you_title.dart';
import 'package:jedi/category/details/blocks/recommend_you.dart';
import 'package:jedi/category/details/blocks/product_description.dart';
import 'package:jedi/internet/api_navigation.dart';

/// 自定义的商品详情页面组件。
class DetailsPage extends StatefulWidget {
  /// 商品信息。
  final Map item;

  DetailsPage({
    this.item,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

/// 与自定义的商品详情页面组件关联的状态子类。
class _DetailsPageState extends State<DetailsPage> {
  /// 滚动控制器（`ScrollController`）对象，控制可滚动的组件。
  ScrollController _controller = ScrollController();

  /// 滚动视图处于什么高度坐标时切换应用栏的图标。
  double _switchHeight;

  /// 当前应用栏的图标是否已经切换。
  bool _isSwitch = false;

  @override
  void initState() {
    // 通过滚动控制器（`ScrollController`）对象给滚动视图添加监听事件。
    _controller.addListener(() {
      _switchHeight = MediaQuery.of(context).size.width -
          MediaQuery.of(context).size.width / 5;
      // 根据当前滚动位置控制应用栏的图标颜色，切换黑底白色或黑色。
      if (_controller.offset > _switchHeight) {
        // 避免频繁更新当前组件。
        if (_isSwitch != true) {
          _isSwitch = true;
          setState(() {});
        }
      } else {
        // 避免频繁更新当前组件。
        if (_isSwitch != false) {
          _isSwitch = false;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: apiTaobaoMaterialOptional(
        typeid: 0,
        q: '喜欢',
        pagesize: 20,
        pageno: 1,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            // 自定义滚动视图（`CustomScrollView`）组件，用于创建一个自定义滚动效果的滚动视图。
            body: CustomScrollView(
              controller: _controller,
              slivers: <Widget>[
                // 裂片应用栏（`SliverAppBar`）组件，与自定义滚动视图（`CustomScrollView`）组件集成的应用栏。
                SliverAppBar(
                  // 浮动（`floating`）属性，滑动到最上面，再滑动是否隐藏导航栏的文字和标题等的具体内容，
                  // 为`true`是隐藏，为`false`（默认）是不隐藏。
                  floating: false,
                  // 固定（`pinned`）属性，是否固定导航栏，为`true`是固定，为`false`（默认）是不固定，往上滑，导航栏可以隐藏。
                  pinned: true,
                  // 只跟浮动（`floating`）属性相对应，如果为`true`，浮动（`floating`）属性必须为`true`，
                  // 也就是向下滑动一点儿，整个大背景就会动画显示全部，往上滑动整个导航栏的内容就会消失。
                  snap: false,
                  // 背景色（`backgroundColor`）属性，用于应用栏材质的颜色。
                  backgroundColor: Color(0xffFFFFFF),
                  // 亮度（`brightness`）属性，应用栏材质的亮度。
                  brightness: Brightness.light,
                  // 媒体查询数据（`MediaQueryData`）类的大小（`size`）属性，逻辑像素中的媒体大小，即屏幕的大小。
                  // 媒体查询数据（`MediaQueryData`）类的填充（`padding`）属性，应用程序可以呈现的显示矩形每一侧的物理像素数。
                  // 填充（`padding`）属性的顶部（`top`）值是状态栏高度，底部（`bottom`）值是系统操作栏高度。
                  // 扩展高度（`expandedHeight`）属性默认高度是状态栏和导航栏的高度，如果有滚动视差的话，要大于前两者的高度。
                  expandedHeight: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).padding.top,
                  // 海拔（`elevation`）属性，阴影的高度。
                  elevation: 0.0,
                  // 灵活的空间（`flexibleSpace`）属性，堆叠在工具栏和标签栏后面，它的高度与应用栏的整体高度相同。
                  // 灵活的空间栏（`FlexibleSpaceBar`）组件，可以扩展和折叠的应用栏子组件。
                  flexibleSpace: FlexibleSpaceBar(
                    // 背景（`background`）属性，展开后显示在标题后面。
                    background: ProductExhibitionArea(
                      imgList: widget.item['smallImages'],
                      imageurlHead: widget.item['isselfupport'] == '2'
                          ? ''
                          : imageurlHeadGoodsgroups,
                      zkfinalprice: widget.item['zkfinalprices'],
                    ),
                    // 折叠模式（`collapseMode`）属性，滚动时折叠效果。
                    collapseMode: CollapseMode.parallax,
                  ),
                  // 设置应用栏是否需要显示前置组件，就是系统默认的返回按钮。
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        // 显示“返回”按钮的剪辑椭圆形（`ClipOval`）组件。
                        child: ClipOval(
                          child: Container(
                            height: 32.0,
                            width: 32.0,
                            alignment: Alignment.center,
                            // 根据当前应用栏的图标是否已经切换显示不同的图片。
                            child: Image.asset(_isSwitch
                                ? 'assets/details_black_back.png'
                                : 'assets/details_white_back.png'),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // 显示“收藏”按钮的剪辑椭圆形（`ClipOval`）组件。
                          ClipOval(
                            child: Container(
                              height: 32.0,
                              width: 32.0,
                              alignment: Alignment.center,
                              // 根据当前应用栏的图标是否已经切换显示不同的图片。
                              child: Image.asset(_isSwitch
                                  ? 'assets/details_black_collection.png'
                                  : 'assets/details_white_collection.png'),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // 显示“更多”按钮的剪辑椭圆形（`ClipOval`）组件。
                          ClipOval(
                            child: Container(
                              height: 32.0,
                              width: 32.0,
                              alignment: Alignment.center,
                              // 根据当前应用栏的图标是否已经切换显示不同的图片。
                              child: Image.asset(_isSwitch
                                  ? 'assets/details_black_more.png'
                                  : 'assets/details_white_more.png'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ProductDescription(
                  reserveprice: double.parse(widget.item['zkFinalPrice']),
                  title: widget.item['title'],
                  taobaousertype: widget.item['userType'],
                  volume: widget.item['volume'],
                  // estimatedprice: snapshot.data['estimatedprice'],
                  nick: widget.item['shopTitle'],
                ),
                ProductDetails(),
                RecommendYouTitle(),
                RecommendYou(
                  items: snapshot.data['outGetMaterialDetailList'],
                ),
              ],
            ),
            // 底部导航栏（`bottomNavigationBar`）属性，显示在脚手架底部的组件。
            bottomNavigationBar: BottomAppBar(
              child: SharingAndCollar(
                couponAmount: widget.item['couponAmount'],
                couponShareUrl: widget.item['couponShareUrl'],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
