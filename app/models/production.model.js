//Import db config built by sequelize library
const sequelize = require("../configs/db.config");
const { DataTypes } = require("sequelize");

const Production = sequelize.define(
  "production_outputs",
  {
    production_id: {
      type: DataTypes.NUMBER,
      primaryKey: true,
    },
    product_id: DataTypes.NUMBER,
    output_quantity: DataTypes.NUMBER,
    damaged_packaging: DataTypes.NUMBER,
    production_date: DataTypes.DATE,
  },
  {
    timestamps: false,
  }
);

module.exports = {
    Production
}
