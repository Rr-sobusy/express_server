//uuid
const { v4: uuidV4 } = require("uuid");

//import sequelize configs
const sequelize = require("../configs/db.config");

//import the defined models
const { Sales, SalesItems } = require("../models/sales.model");
const { Products } = require("../models/product.model");
const { StocksChange } = require("../models/stocksFlow.model");

async function fetchSalesDatas(req, res) {
  //Define relationships

  // Sales has many sales instances/sales_items
  Sales.hasMany(SalesItems, {
    foreignKey: "sales_id",
  });
  SalesItems.belongsTo(Sales, {
    foreignKey: "sales_id",
  });

  const result = await Sales.findAll({
    include: [
      {
        model: SalesItems,
        attributes: [
          "sales_item_id",
          "quantity",
          [
            //Add a virtual column -- product_name coming from products table
            sequelize.literal(
              `(Select product_name from products where product_id = sales_items.product_id)`
            ),
            "productName",
          ],
          [
            //Add a virtual column -- packaging size coming from products table
            sequelize.literal(
              `(Select packaging_size from products where product_id = sales_items.product_id)`
            ),
            "packagingSize",
          ],
        ],
      },
    ],
    //Order the results by sales id descenging
    order: [["sales_id", "desc"]],
  });

  //Forward the datas fetched
  res.json(result);
}

//Add New sales instance with its sales items
async function addNewSales(req, res) {
  // Request bodies
  const { customerName, salesTime, salesDate, salesItems } = req.body;

  // create uuid for identity in changing the stocks flow
  const updateKey = uuidV4();

  //Convert salesItem json to an javascript object
  const itemsArray = JSON.parse(salesItems);

  const result = await Sales.create({
    customer_name: customerName,
  }).then(async function () {
    //Fetch latest Id
    const latestSalesID = await Sales.findOne({
      attributes: ["sales_id"],
      order: [["sales_id", "desc"]],
    });

    //iterate the sales items according to json request and insert to it database
    itemsArray.map(function (items) {
      SalesItems.create({
        sales_id: parseInt(latestSalesID.sales_id, 10),
        product_id: parseFloat(items.productId, 10),
        quantity: parseFloat(items.quantity, 10),
      }).then(function () {
        //Save the updates to stocks changes flow
      });
    });
  });

  //
  res.json("success");
}

module.exports = {
  fetchSalesDatas,
  addNewSales,
};
