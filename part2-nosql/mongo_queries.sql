// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "product_id": "ELEC-99201",
    "name": "UltraView 27-inch 4K Monitor",
    "category": "Electronics",
    "brand": "TechVision",
    "specifications": {
      "resolution": "3840x2160",
      "panel_type": "IPS",
      "refresh_rate": "144Hz",
      "ports": ["HDMI 2.1", "DisplayPort 1.4", "USB-C"],
      "voltage": "110-240V"
    },
    "unit_price": 45000,
    "warranty": {
      "duration_months": 36,
      "type": "Manufacturer Limited"
    },
    "in_stock": true
  },
  {
    "product_id": "CLOT-44012",
    "name": "Classic Fit Denim Jacket",
    "category": "Clothing",
    "material": "98% Cotton, 2% Elastane",
    "attributes": {
      "gender": "Unisex",
      "sizes": ["S", "M", "L", "XL"],
      "colors": [
        {"name": "Indigo", "hex": "#2E4053"},
        {"name": "Light Wash", "hex": "#AED6F1"}
      ]
    },
    "unit_price": 2500,
    "collection": "Spring 2026"
  },
  {
    "product_id": "GROC-11055",
    "name": "Organic Almond Milk (Unsweetened)",
    "category": "Groceries",
    "volume": "1 Liter",
    "nutritional_info": {
      "calories": 30,
      "allergens": ["Tree Nuts"]
    },
    "batch_details": {
      "manufacture_date": "2026-03-01",
      "expiry_date": ISODate("2026-09-01"),
      "is_perishable": true
    },
    "unit_price": 150
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({
  "category": "Electronics",
  "unit_price": { $gt: 20000 }
});

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({
  "category": "Groceries",
  "batch_details.expiry_date": { $lt: ISODate("2025-01-01") }
});

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { "product_id": "ELEC-99201" },
  { $set: { "discount_percent": 15 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ "category": 1 });
