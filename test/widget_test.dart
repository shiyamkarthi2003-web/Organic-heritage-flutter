import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:organic_heritage_flutter/pages/checkout.dart';
import 'package:organic_heritage_flutter/main.dart';

void main() {
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
