//import sequelize configs
const sequelize = require("../configs/db.config");

//import the defined models
const { Sales, SalesItems } = require("../models/sales.model");
const { Products } = require("../models/product.model");

async function fetchSalesDatas(req, res) {
  //Define relationships

  // Sales has many sales instances
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
          "id",
          "quantity",
          [
            //Add a virtual column that contains the product name
            sequelize.literal(
              `(Select product_name from products where product_id = sales_items.product_id)`
            ),
            "productName",
          ],
        ],
      },
    ],
    //Order the results by sales id descenging
    order: [["sales_id", "desc"]],
  });
  res.json(result);
}

module.exports = {
  fetchSalesDatas,
};
