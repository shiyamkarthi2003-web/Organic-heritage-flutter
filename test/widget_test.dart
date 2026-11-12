import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:organic_heritage_flutter/pages/checkout.dart';
import 'package:organic_heritage_flutter/main.dart';
import 'package:organic_heritage_flutter/state/cart_store.dart';
import 'package:organic_heritage_flutter/widgets/common_widgets.dart';

void main() {
  testWidgets('home value cards use compact vertical spacing', (tester) async {
    await tester.pumpWidget(const OrganicHeritageApp());
    await tester.scrollUntilVisible(
      find.text('Pure & Authentic'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final valueCard = find.ancestor(
      of: find.text('Pure & Authentic'),
      matching: find.byType(InfoCard),
    );
    expect(valueCard, findsOneWidget);

    final cardSize = tester.getSize(valueCard);
    expect(cardSize.width / cardSize.height, greaterThan(1.6));
  });

  testWidgets('shop to product to basket flow works', (tester) async {
    await tester.pumpWidget(const OrganicHeritageApp());

    expect(
      find.text('Pure Organic Nutrition\n& Botanical Care'),
      findsOneWidget,
    );

    await tester.tap(find.text('Shop').last);
    await tester.pumpAndSettle();
    expect(find.text('Organic Heritage Grains'), findsOneWidget);
    expect(find.text('Face Glow Oil'), findsNothing);
    expect(find.text('Herbal Karisalankani Baby Kajal'), findsNothing);
    expect(find.text('Sanitary Pads made with Tapioca Fiber'), findsNothing);

    final productName = find.text('Karuppu Kavuni Rice').first;
    await tester.ensureVisible(productName);
    await tester.pumpAndSettle();
    await tester.tap(productName);
    await tester.pumpAndSettle();

    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('SACRED PROVENANCE'), findsNothing);
    expect(find.text('Murugesan’s Heritage Farm'), findsNothing);
    await tester.tap(find.text('Add to Sacred Basket · ₹210'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Basket'));
    await tester.pumpAndSettle();

    expect(find.text('Your Sacred Basket'), findsOneWidget);
    expect(find.text('Karuppu Kavuni Rice'), findsOneWidget);
    expect(find.textContaining('1 Item'), findsOneWidget);

    final checkoutButton = find.widgetWithText(
      FilledButton,
      'Proceed to Sacred Checkout',
    );
    await tester.ensureVisible(checkoutButton);
    await tester.tap(checkoutButton);
    await tester.pumpAndSettle();
    expect(find.text('Checkout'), findsOneWidget);
    final checkoutScrollable = find.descendant(
      of: find.byType(CheckoutPage),
      matching: find.byType(Scrollable),
    );
    await tester.drag(checkoutScrollable.first, const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(find.textContaining('Payment Protocol'), findsOneWidget);
  });

  testWidgets('bottom cart tab updates and shows added products', (
    tester,
  ) async {
    final store = CartStore();
    await tester.pumpWidget(OrganicHeritageApp(store: store));

    await tester.tap(find.text('Shop').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -260));
    await tester.pumpAndSettle();

    final addButton = find.widgetWithText(FilledButton, 'Add').first;
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    final cartItem = find
        .ancestor(of: find.text('Cart').last, matching: find.byType(InkWell))
        .first;
    final cartBadge = find.descendant(
      of: cartItem,
      matching: find.byType(Badge),
    );
    expect(tester.widget<Badge>(cartBadge).isLabelVisible, isTrue);
    expect(
      find.descendant(of: cartBadge, matching: find.text('1')),
      findsOneWidget,
    );

    await tester.tap(find.text('Cart').last);
    await tester.pumpAndSettle();
    expect(find.text('Your Sacred Basket'), findsOneWidget);
    expect(store.productsInCart, hasLength(1));
  });

  testWidgets('grain catalog displays all attached package images', (
    tester,
  ) async {
    await tester.pumpWidget(const OrganicHeritageApp());
    await tester.tap(find.text('Shop').last);
    await tester.pumpAndSettle();

    final grainImageAssets = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => image.image)
        .whereType<AssetImage>()
        .map((image) => image.assetName)
        .where((assetName) => assetName.startsWith('assets/grains/'))
        .toSet();

    expect(grainImageAssets, hasLength(20));
    expect(find.text('Thuyamalli Puttu Flour'), findsOneWidget);
    expect(find.text('Thanjavur Special Killu Vadam'), findsOneWidget);
    expect(find.text('Traditional Mappillai Samba Rice'), findsNothing);
    expect(find.text('Barnyard Millet & Pulse Blend'), findsNothing);
  });

  testWidgets('cosmetics catalog displays all attached product images', (
    tester,
  ) async {
    await tester.pumpWidget(const OrganicHeritageApp());
    await tester.tap(find.text('Shop').last);
    await tester.pumpAndSettle();

    final cosmeticImageAssets = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => image.image)
        .whereType<AssetImage>()
        .map((image) => image.assetName)
        .where((assetName) => assetName.startsWith('assets/cosmetics/'))
        .toSet();

    expect(cosmeticImageAssets, hasLength(18));
    expect(find.text('Natural Lipstick - Light Red'), findsOneWidget);
    expect(find.text('Herbal Hair Mask Powder'), findsOneWidget);
  });

  testWidgets('search, notifications, and profile pages open', (tester) async {
    await tester.pumpWidget(const OrganicHeritageApp());

    await tester.tap(find.byTooltip('Search').first);
    await tester.pumpAndSettle();
    expect(find.text('Trending Herbal Searches'), findsOneWidget);

    await tester.tap(find.byTooltip('Notifications').first);
    await tester.pumpAndSettle();
    expect(find.text('Harvest Dispatched: Order #OH-89241'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Lakshmanan S.'), findsOneWidget);
  });
}
