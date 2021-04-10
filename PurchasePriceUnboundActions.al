codeunit 50102 "Purchase price unbound action"
{

    /// <summary>
    /// Update or insert purchase price and discount
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="vendor">Vendor number</param>
    /// <param name="uom">Unit of measure</param>
    /// <param name="quantity">Minimum quantity</param>
    /// <param name="cost">Direct unit cost</param>
    /// <param name="discount">Line discount percentage</param>
    /// <returns></returns>
    procedure UpdatePurchasePriceDiscount(item: Text; vendor: Text; uom: Text; quantity: Decimal; cost: Decimal; discount: Decimal): Text
    var
        PurchasePrice: Record "Purchase Price";
        PurchaseDiscount: Record "Purchase Line Discount";
    begin

        if PurchasePrice.Get(item, vendor, 0D, '', '', uom, quantity) then begin
            PurchasePrice."Direct Unit Cost" := cost;
            PurchasePrice.Modify;
        end
        else begin
            PurchasePrice.Init;
            PurchasePrice."Item No." := item;
            PurchasePrice."Vendor No." := vendor;
            PurchasePrice."Unit of Measure Code" := uom;
            PurchasePrice."Minimum Quantity" := quantity;
            PurchasePrice."Direct Unit Cost" := cost;
            PurchasePrice.Insert;
        end;

        if PurchaseDiscount.Get(item, vendor, 0D, '', '', uom, quantity) then begin
            PurchaseDiscount."Line Discount %" := discount;
            PurchaseDiscount.Modify;
        end
        else begin
            PurchaseDiscount.Init;
            PurchaseDiscount."Item No." := item;
            PurchaseDiscount."Vendor No." := vendor;
            PurchaseDiscount."Unit of Measure Code" := uom;
            PurchaseDiscount."Minimum Quantity" := quantity;
            PurchaseDiscount."Line Discount %" := discount;
            PurchaseDiscount.Insert;
        end;

        exit('Purchase price and discount updated');
    end;

    /// <summary>
    /// Delete all purchase prices and discounts by item number and vendor number
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="vendor">Vendor number</param>
    /// <returns></returns>
    procedure DeletePurchasePriceDiscount(item: Text; vendor: Text): Text
    var
        PurchasePrice: Record "Purchase Price";
        PurchaseDiscount: Record "Purchase Line Discount";
    begin
        PurchasePrice.SetFilter(PurchasePrice."Item No.", '%1', item);
        PurchasePrice.SetFilter(PurchasePrice."Vendor No.", '%1', vendor);
        if PurchasePrice.FindFirst then
            PurchasePrice.DeleteAll;

        PurchaseDiscount.SetFilter(PurchaseDiscount."Item No.", '%1', item);
        PurchaseDiscount.SetFilter(PurchaseDiscount."Vendor No.", '%1', vendor);
        if PurchaseDiscount.FindFirst then
            PurchaseDiscount.DeleteAll;

        exit('Delete all prices and discounts by item and vendor');
    end;

}