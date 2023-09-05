const { Production } = require("../models/production.model");
const { Products } = require("../models/product.model");
async function fetchProductionDetails(req, res) {
  Production.belongsTo(Products, {
    foreignKey: "product_id",
  });

  const data = await Production.findAll({
    include: [
      {
        model: Products,
        attributes: ["product_name","packaging_size"],
      },
    ],
  });
  res.json(data);
}

module.exports = {
  fetchProductionDetails,
};
