import 'dart:convert';

class LoginInfo {
  int userID;
  String token;

  LoginInfo(this.userID, this.token);

  factory LoginInfo.fromJson(dynamic jsonData) {
    return LoginInfo(jsonData['id'] as int, jsonData['token'] as String);
  }

  @override
  String toString() {
    return '{${this.userID},${this.token}}';
  }
}

class UserLinks {
  String cartLink;
  String ordersLink;
  String receiptsLink;
  String selfLink;
  String profilePicLink;

  UserLinks(this.cartLink, this.ordersLink, this.receiptsLink, this.selfLink,
      this.profilePicLink);

  factory UserLinks.fromJson(dynamic jsonData) {
    return UserLinks(
        jsonData['cart'] as String, //Bug
        jsonData['orders'] as String,
        jsonData['receipts'] as String,
        jsonData['self'] as String,
        jsonData['selfie_file'] as String);
  }

  @override
  String toString() {
    return '{${this.cartLink},${this.ordersLink},${this.receiptsLink},${this.selfLink},${this.profilePicLink}}';
  }
}

class BasicUserInfo {
  UserLinks userLinks;
  String givenName, lastName, phoneNum, username;

  BasicUserInfo(this.userLinks, this.givenName, this.lastName, this.phoneNum,
      this.username);

  factory BasicUserInfo.fromJson(dynamic jsonData) {
    return BasicUserInfo(
        UserLinks.fromJson(jsonData['_links']),
        jsonData['given_name'] as String,
        jsonData['last_name'] as String,
        jsonData['phone'] as String,
        jsonData['username'] as String);
  }

  @override
  String toString() {
    return '{${this.userLinks},${this.givenName},${this.lastName},${this.phoneNum},${this.username}}';
  }
}

class DetailedUserInfo {
  UserLinks links;
  int userID;
  String aboutMe,
      address,
      allergies,
      building,
      country,
      countryCode,
      designation,
      givenName,
      idReg,
      idType,
      lastName,
      lastSeen,
      nationality,
      phoneNo,
      preExisitngCon,
      selfieFile,
      unitNo,
      username,
      zipCode;

  DetailedUserInfo(
      this.links,
      this.aboutMe,
      this.address,
      this.allergies,
      this.building,
      this.country,
      this.countryCode,
      this.designation,
      this.givenName,
      this.userID,
      this.idReg,
      this.idType,
      this.lastName,
      this.lastSeen,
      this.nationality,
      this.phoneNo,
      this.preExisitngCon,
      this.selfieFile,
      this.unitNo,
      this.username,
      this.zipCode);

  factory DetailedUserInfo.fromJson(dynamic jsonData) {
    return DetailedUserInfo(
        UserLinks.fromJson(jsonData['_links']),
        jsonData['about_me'] as String,
        jsonData['address'] as String,
        jsonData['allergies'] as String,
        jsonData['building'] as String,
        jsonData['country'] as String,
        jsonData['country_code'] as String,
        jsonData['designation'] as String,
        jsonData['given_name'] as String,
        jsonData['id'] as int,
        jsonData['id_reg'] as String,
        jsonData['id_type'] as String,
        jsonData['last_name'] as String,
        jsonData['last_seen'] as String,
        jsonData['nationality'] as String,
        jsonData['phone'] as String,
        jsonData['pre_existing'] as String,
        jsonData['selfie_file'] as String,
        jsonData['unit_num'] as String,
        jsonData['username'] as String,
        jsonData['zip_code'] as String);
  }

  @override
  String toString() {
    return '{${this.links},${this.aboutMe},${this.address},${this.allergies},${this.building},${this.country},${this.countryCode},${this.designation},${this.givenName},${this.userID},${this.idReg},${this.idType},${this.lastName},${this.lastSeen},${this.nationality},${this.phoneNo},${this.preExisitngCon},${this.selfieFile},${this.unitNo},${this.username},${this.zipCode},}';
  }
}

class ProductLinks {
  String nextPage, prevPage, curPage;

  ProductLinks(this.nextPage, this.prevPage, this.curPage);

  factory ProductLinks.fromJson(dynamic jsonData) {
    return ProductLinks(jsonData['next'] as String, jsonData['prev'] as String,
        jsonData['self'] as String);
  }

  @override
  String toString() {
    return '{${this.nextPage},${this.prevPage},${this.curPage}}';
  }
}

class ProductMeta {
  int pageNo, perPage, totalItems, totalPages;

  ProductMeta(this.pageNo, this.perPage, this.totalItems, this.totalPages);

  factory ProductMeta.fromJson(dynamic jsonData) {
    return ProductMeta(jsonData['page'] as int, jsonData['per_page'] as int,
        jsonData['total_items'] as int, jsonData['total_pages'] as int);
  }

  @override
  String toString() {
    return '{${this.pageNo},${this.perPage},${this.totalItems},${this.totalPages}}';
  }
}

class ItemLinks {
  String featurePic, selfLink, supplierLink;

  ItemLinks(this.featurePic, this.selfLink, this.supplierLink);

  factory ItemLinks.fromJson(dynamic jsonData) {
    return ItemLinks(jsonData['feature_picture'] as String,
        jsonData['self'] as String, jsonData['supplier'] as String);
  }

  @override
  String toString() {
    return '{${this.featurePic},${this.selfLink},${this.supplierLink}}';
  }
}

class ProductArr {
  ItemLinks links;
  int amount, companyID, productID;
  String brand, createdOn, currency, description, featurePic, model;

  ProductArr(
      this.links,
      this.amount,
      this.brand,
      this.companyID,
      this.createdOn,
      this.currency,
      this.description,
      this.featurePic,
      this.productID,
      this.model);

  factory ProductArr.fromJson(dynamic jsonData) {
    return ProductArr(
        ItemLinks.fromJson(jsonData['_links']),
        jsonData['amount'] as int,
        jsonData['brand'] as String,
        jsonData['company_id'] as int,
        jsonData['created_on'] as String,
        jsonData['currency'] as String,
        jsonData['description'] as String,
        jsonData['feature_picture'] as String,
        jsonData['id'] as int,
        jsonData['model'] as String);
  }

  @override
  String toString() {
    return '{${this.links},${this.amount},${this.brand},${this.companyID},${this.createdOn},${this.currency},${this.description},${this.featurePic},${this.productID},${this.model}}';
  }
}

class ProductInfo {
  ProductLinks linkData;
  ProductMeta metaData;
  List<ProductArr> itemArr;

  ProductInfo(this.linkData, this.metaData, [this.itemArr]);

  factory ProductInfo.fromJson(dynamic jsonData) {
    if (jsonData['items'] != null) {
      var arrObj = jsonData['items'] as List;
      List<ProductArr> itemArr =
          arrObj.map((arrJson) => ProductArr.fromJson(arrJson)).toList();

      return ProductInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']), itemArr);
    } else {
      return ProductInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']));
    }
  }

  @override
  String toString() {
    return '{${this.linkData},${this.metaData},${this.itemArr}}';
  }
}

class ReceiptCartLinks {
  String featurePic, selfLink;

  ReceiptCartLinks(this.featurePic, this.selfLink);

  factory ReceiptCartLinks.fromJson(dynamic jsonData) {
    return ReceiptCartLinks(
        jsonData['feature_picture'] as String, jsonData['self'] as String);
  }

  @override
  String toString() {
    return '{${this.featurePic},${this.selfLink}}';
  }
}

class ReceiptCartArr {
  ReceiptCartLinks links;
  int amount,
      discount,
      unknownID,
      orderID,
      orderReceivedID,
      productID,
      quantity,
      receiptID,
      supplierID,
      totalAmt;
  String brand, currency, featurePic, model;

  ReceiptCartArr(
      this.links,
      this.amount,
      this.brand,
      this.currency,
      this.discount,
      this.featurePic,
      this.unknownID,
      this.model,
      this.orderID,
      this.orderReceivedID,
      this.productID,
      this.quantity,
      this.receiptID,
      this.supplierID,
      this.totalAmt);

  factory ReceiptCartArr.fromJson(dynamic jsonData) {
    if (jsonData['discount'] == null) {
      return ReceiptCartArr(
          ReceiptCartLinks.fromJson(jsonData['_links']),
          jsonData['amount'] as int,
          jsonData['brand'] as String,
          jsonData['currency'] as String,
          0,
          jsonData['feature_picture'] as String,
          jsonData['id'] as int,
          jsonData['model'] as String,
          jsonData['order_id'] as int,
          jsonData['order_received_id'] as int,
          jsonData['product_id'] as int,
          jsonData['quantity'] as int,
          jsonData['receipt_id'] as int,
          jsonData['supplier_id'] as int,
          jsonData['ttl_amount'] as int);
    } else {
      return ReceiptCartArr(
          ReceiptCartLinks.fromJson(jsonData['_links']),
          jsonData['amount'] as int,
          jsonData['brand'] as String,
          jsonData['currency'] as String,
          jsonData['discount'] as int,
          jsonData['feature_picture'] as String,
          jsonData['id'] as int,
          jsonData['model'] as String,
          jsonData['order_id'] as int,
          jsonData['order_received_id'] as int,
          jsonData['product_id'] as int,
          jsonData['quantity'] as int,
          jsonData['receipt_id'] as int,
          jsonData['supplier_id'] as int,
          jsonData['ttl_amount'] as int);
    }
  }

  @override
  String toString() {
    return '{${this.links},${this.amount},${this.brand},${this.currency},${this.discount},${this.featurePic},${this.unknownID},${this.model},${this.orderID},${this.orderReceivedID},${this.productID},${this.quantity},${this.receiptID},${this.supplierID},${this.totalAmt}}';
  }
}

class ReceiptCartInfo {
  ProductLinks linkData;
  ProductMeta metaData;
  List<ReceiptCartArr> itemArr;

  ReceiptCartInfo(this.linkData, this.metaData, [this.itemArr]);

  factory ReceiptCartInfo.fromJson(dynamic jsonData) {
    if (jsonData['items'] != null) {
      var arrObj = jsonData['items'] as List;
      List<ReceiptCartArr> itemArr =
          arrObj.map((arrJson) => ReceiptCartArr.fromJson(arrJson)).toList();

      return ReceiptCartInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']), itemArr);
    } else {
      return ReceiptCartInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']));
    }
  }

  @override
  String toString() {
    return '{${this.linkData},${this.metaData},${this.itemArr}}';
  }
}

class CartLinks {
  String featurePic, selfLink;

  CartLinks(this.featurePic, this.selfLink);

  factory CartLinks.fromJson(dynamic jsonData) {
    return CartLinks(
        jsonData['feature_picture'] as String, jsonData['self'] as String);
  }

  @override
  String toString() {
    return '{${this.featurePic},${this.selfLink}}';
  }
}

class CartItemsArr {
  CartLinks links;
  int amount, discount, id, productID, quantity, supplierID, totalAmt;
  String brand,
      currency,
      featurePic,
      model,
      orderID,
      orderReceivedID,
      receiptID;

  CartItemsArr(
      this.links,
      this.amount,
      this.brand,
      this.currency,
      this.discount,
      this.featurePic,
      this.id,
      this.model,
      this.orderID,
      this.orderReceivedID,
      this.productID,
      this.quantity,
      this.receiptID,
      this.supplierID,
      this.totalAmt);

  factory CartItemsArr.fromJson(dynamic jsonData) {
    return CartItemsArr(
        CartLinks.fromJson(jsonData['_links']),
        jsonData['amount'] as int,
        jsonData['brand'] as String,
        jsonData['currency'] as String,
        jsonData['discount'] as int,
        jsonData['feature_picture'] as String,
        jsonData['id'] as int,
        jsonData['model'] as String,
        jsonData['order_id'] as String,
        jsonData['order_received_id'] as String,
        jsonData['product_id'] as int,
        jsonData['quantity'] as int,
        jsonData['receipt_id'] as String,
        jsonData['supplier_id'] as int,
        jsonData['ttl_amount'] as int);
  }

  @override
  String toString() {
    return '{${this.links},${this.amount},${this.brand},${this.currency},${this.discount},${this.featurePic},${this.id},${this.model},${this.orderID},${this.orderReceivedID},${this.productID},${this.quantity},${this.receiptID},${this.supplierID},${this.totalAmt},}';
  }
}

class CartInfo {
  ProductLinks linksData;
  ProductMeta metaData;
  List<CartItemsArr> itemsArr;

  CartInfo(this.linksData, this.metaData, [this.itemsArr]);

  factory CartInfo.fromJson(dynamic jsonData) {
    if (jsonData['items'] != null) {
      var arrObj = jsonData['items'] as List;
      List<CartItemsArr> _itemsArr =
          arrObj.map((arrJson) => CartItemsArr.fromJson(arrJson)).toList();

      return CartInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']), _itemsArr);
    } else {
      return CartInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']));
    }
  }

  @override
  String toString() {
    return '{${this.linksData},${this.metaData},${this.itemsArr}}';
  }
}

class CartUserLinks {
  String cartItems, self;

  CartUserLinks(this.cartItems, this.self);

  factory CartUserLinks.fromJson(dynamic jsonData) {
    return CartUserLinks(
        jsonData['cart_items'] as String, jsonData['self'] as String);
  }

  @override
  String toString() {
    return '{${this.cartItems},${this.self}}';
  }
}

class CartUserInfo {
  CartUserLinks links;
  int cartItemsCount, cartID, userID;

  CartUserInfo(this.links, this.cartItemsCount, this.cartID, this.userID);

  factory CartUserInfo.fromJson(dynamic jsonData) {
    return CartUserInfo(
        CartUserLinks.fromJson(jsonData['_links']),
        jsonData['cart_items_count'] as int,
        jsonData['id'] as int,
        jsonData['user_id'] as int);
  }

  @override
  String toString() {
    return '{${this.links},${this.cartItemsCount},${this.cartID},${this.userID}}';
  }
}

class PaymentTokens {
  int cartID;
  String publicKey, sessionID;

  PaymentTokens(this.cartID, this.publicKey, this.sessionID);

  factory PaymentTokens.fromJson(dynamic jsonData) {
    return PaymentTokens(
        jsonData['cart_id'] as int,
        jsonData['checkout_public_key'] as String,
        jsonData['checkout_session_id'] as String);
  }

  @override
  String toString() {
    return '{${this.cartID},${this.publicKey},${this.sessionID}}';
  }
}

class OrderLinks {
  String cartItems, self;

  OrderLinks(this.cartItems, this.self);

  factory OrderLinks.fromJson(dynamic jsonData) {
    return OrderLinks(
        jsonData['cart_items'] as String, jsonData['self'] as String);
  }

  @override
  String toString() {
    return '{${this.cartItems},${this.self}}';
  }
}

class OrderDetails {
  OrderLinks orderLinks;
  int buyerID, id;
  String timestamp;

  OrderDetails(this.orderLinks, this.buyerID, this.timestamp, this.id);

  factory OrderDetails.fromJson(dynamic jsonData) {
    return OrderDetails(
        OrderLinks.fromJson(jsonData['_links']),
        jsonData['buyer_id'] as int,
        jsonData['created_on'] as String,
        jsonData['id'] as int);
  }

  @override
  String toString() {
    return '{${this.orderLinks},${this.buyerID},${this.timestamp},${this.id}}';
  }
}

class UserOrders {
  ProductLinks links;
  ProductMeta meta;
  List<OrderDetails> orderArr;

  UserOrders(this.links, this.meta, [this.orderArr]);

  factory UserOrders.fromJson(dynamic jsonData) {
    if (jsonData['items'] != null) {
      var arrObj = jsonData['items'] as List;
      List<OrderDetails> _orderArr =
          arrObj.map((arrJson) => OrderDetails.fromJson(arrJson)).toList();

      return UserOrders(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']), _orderArr);
    } else {
      return UserOrders(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']));
    }
  }

  @override
  String toString() {
    return '{${this.links},${this.meta},${this.orderArr}}';
  }
}

class BasicIndexReceipt {
  OrderLinks links;
  String timestamp;
  int customerID, receiptID;

  BasicIndexReceipt(
      this.links, this.timestamp, this.customerID, this.receiptID);

  factory BasicIndexReceipt.fromJson(dynamic jsonData) {
    return BasicIndexReceipt(
        OrderLinks.fromJson(jsonData['_links']),
        jsonData['created_on'] as String,
        jsonData['customer_id'] as int,
        jsonData['id'] as int);
  }

  @override
  String toString() {
    return '{${this.links},${this.timestamp},${this.customerID},${this.receiptID}}';
  }
}

class ReceiptInfo {
  ProductLinks linkData;
  ProductMeta metaData;
  List<BasicIndexReceipt> itemArr;

  ReceiptInfo(this.linkData, this.metaData, [this.itemArr]);

  factory ReceiptInfo.fromJson(dynamic jsonData) {
    if (jsonData['items'] != null) {
      var arrObj = jsonData['items'] as List;
      List<BasicIndexReceipt> itemArr =
          arrObj.map((arrJson) => BasicIndexReceipt.fromJson(arrJson)).toList();

      return ReceiptInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']), itemArr);
    } else {
      return ReceiptInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']));
    }
  }

  @override
  String toString() {
    return '{${this.linkData},${this.metaData},${this.itemArr}}';
  }
}

class CompanyLinks {
  String logoFile, productLinks, self;

  CompanyLinks(this.logoFile, this.productLinks, this.self);

  factory CompanyLinks.fromJson(dynamic jsonData) {
    return CompanyLinks(jsonData['logo_file'] as String,
        jsonData['products'] as String, jsonData['self'] as String);
  }

  @override
  String toString() {
    return '{${this.logoFile},${this.productLinks},${this.self}}';
  }
}

class CompanyArr {
  CompanyLinks links;
  String timestamp, logoFile, companyName;
  int companyID;
  double latitude, longitude;

  CompanyArr(this.links, this.timestamp, this.companyID, this.latitude,
      this.logoFile, this.longitude, this.companyName);

  factory CompanyArr.fromJson(dynamic jsonData) {
    return CompanyArr(
        CompanyLinks.fromJson(jsonData['_links']),
        jsonData['created_on'] as String,
        jsonData['id'] as int,
        jsonData['lat'] as double,
        jsonData['logo_file'] as String,
        jsonData['lon'] as double,
        jsonData['name'] as String);
  }

  @override
  String toString() {
    return '{${this.links},${this.timestamp},${this.companyID},${this.latitude},${this.logoFile},${this.longitude},${this.companyName},}';
  }
}

class CompanyInfo {
  ProductLinks links;
  ProductMeta meta;
  List<CompanyArr> companyArr;

  CompanyInfo(this.links, this.meta, [this.companyArr]);

  factory CompanyInfo.fromJson(dynamic jsonData) {
    if (jsonData['items'] != null) {
      var arrObj = jsonData['items'] as List;
      List<CompanyArr> _companyArr =
          arrObj.map((arrJson) => CompanyArr.fromJson(arrJson)).toList();

      return CompanyInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']), _companyArr);
    } else {
      return CompanyInfo(ProductLinks.fromJson(jsonData['_links']),
          ProductMeta.fromJson(jsonData['_meta']));
    }
  }

  @override
  String toString() {
    return '{${this.links},${this.meta},${this.companyArr}}';
  }
}
