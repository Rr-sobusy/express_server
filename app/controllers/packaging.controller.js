const sequelize = require("../configs/db.config");

//Defined models
const { Packaging, ReleasedPackagings } = require("../models/packaging.model");

async function fetchPackagingDatas(req, res) {
  
  //Fetching the Packagings current datas -- use raw query for getting the current stocks that depends the deliveries and released
  const [result, metadata] =
    await sequelize.query(`select p.packaging_id,p.packaging_name,p.initial_stocks ,
    (select coalesce(sum(dp.delivered_quantity),0) as in from delivered_packagings dp where dp.packaging_id = p.packaging_id),
    (select coalesce(sum(rp.quantity_released), 0) as out from released_packagings rp where rp.packaging_id = p.packaging_id),
    (select coalesce(sum(rp2.quantity_returned), 0) as returned  from returned_packagings rp2 where rp2.packaging_id = p.packaging_id),
    (p.initial_stocks + (select coalesce(sum(dp.delivered_quantity),0) as in from delivered_packagings dp where dp.packaging_id = p.packaging_id) -
      (select coalesce(sum(rp.quantity_released), 0) as out from released_packagings rp where rp.packaging_id = p.packaging_id) +
       (select coalesce(sum(rp2.quantity_returned), 0) as returned  from returned_packagings rp2 where rp2.packaging_id = p.packaging_id) )as current_stocks 
    from packagings p  `);
  res.status(200).json(result);



 
}

//Export function that used
module.exports = {
  fetchPackagingDatas,
};
