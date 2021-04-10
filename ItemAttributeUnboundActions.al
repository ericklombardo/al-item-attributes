codeunit 50100 "Item attribute unbound action"
{

    /// <summary>
    /// Insert attribute value
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="ItemAttr">Attribute record</param>
    /// <param name="val">Value for setup</param>
    local procedure InsertAttributeValue(item: Text; ItemAttr: Record "Item Attribute"; val: Text)
    var
        ItemAttrValues: Record "Item Attribute Value";
        ItemAttrMapping: Record "Item Attribute Value Mapping";
        VarNumber: Decimal;
        VarDate: Date;
    begin
        ItemAttrValues.Init;
        ItemAttrValues."Attribute ID" := ItemAttr.ID;
        ItemAttrValues.Value := val;

        if (ItemAttr.Type = ItemAttr.Type::Decimal) then begin
            if Evaluate(VarNumber, val) then
                ItemAttrValues."Numeric Value" := VarNumber;
        end;
        if (ItemAttr.Type = ItemAttr.Type::Integer) then begin
            if Evaluate(VarNumber, val) then
                ItemAttrValues."Numeric Value" := VarNumber;
        end;
        if (ItemAttr.Type = ItemAttr.Type::Date) then begin
            if Evaluate(VarDate, val) then
                ItemAttrValues."Date Value" := VarDate;
        end;

        ItemAttrValues.Insert;

        ItemAttrMapping.Init;
        ItemAttrMapping."Table ID" := 27;
        ItemAttrMapping."No." := item;
        ItemAttrMapping."Item Attribute ID" := ItemAttr.ID;
        ItemAttrMapping."Item Attribute Value ID" := ItemAttrValues.ID;
        ItemAttrMapping.Insert;
    end;

    /// <summary>
    /// Modify attribute value
    /// </summary>
    /// <param name="ItemAttr">Attribute record</param>
    /// <param name="ItemAttrMapping">Attribute Value Mapping Id</param>
    /// <param name="val">Value for setup</param>
    local procedure ModifyAttributeValue(ItemAttr: Record "Item Attribute"; ItemAttrMapping: Integer; val: Text)
    var
        ItemAttrValues: Record "Item Attribute Value";
        VarNumber: Decimal;
        VarDate: Date;
    begin
        if not ItemAttrValues.Get(ItemAttr.ID, ItemAttrMapping) then
            Error('Item attribute value not found');

        ItemAttrValues.Value := val;
        if (ItemAttr.Type = ItemAttr.Type::Decimal) then begin
            if Evaluate(VarNumber, val) then
                ItemAttrValues."Numeric Value" := VarNumber;
        end;
        if (ItemAttr.Type = ItemAttr.Type::Integer) then begin
            if Evaluate(VarNumber, val) then
                ItemAttrValues."Numeric Value" := VarNumber;
        end;
        if (ItemAttr.Type = ItemAttr.Type::Date) then begin
            if Evaluate(VarDate, val) then
                ItemAttrValues."Date Value" := VarDate;
        end;

        ItemAttrValues.Modify;
    end;

    /// <summary>
    /// Update item atribute value
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="attribute">Attribute Id</param>
    /// <param name="val">Value to setup</param>
    /// <returns></returns>
    procedure UpdateItemAttributeValue(item: Text; attribute: Integer; val: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrMapping: Record "Item Attribute Value Mapping";
    begin

        if not ItemAttr.Get(attribute) then
            Error('Item attribute not found');

        ItemAttrMapping."Table ID" := 27;
        ItemAttrMapping."No." := item;
        ItemAttrMapping."Item Attribute ID" := attribute;
        if not ItemAttrMapping.Find('=') then
            Error('Item attribute mapping not found', item, attribute);

        ModifyAttributeValue(ItemAttr, ItemAttrMapping."Item Attribute Value ID", val);

        exit('item attribute updated');
    end;

    /// <summary>
    /// Insert a new item attribute value
    /// Insert a record in both tables, item attribute values and item attribute value mapping 
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="attribute">Attribute id</param>
    /// <param name="val">Value to setup</param>
    /// <returns></returns>
    procedure InsertItemAttributeValue(item: Text; attribute: Integer; val: Text): Text
    var
        ItemAttr: Record "Item Attribute";
    begin

        if not ItemAttr.Get(attribute) then
            Error('Item attribute not found');

        InsertAttributeValue(item, ItemAttr, val);

        exit('item attribute value inserted');
    end;

    /// <summary>
    /// Delete item attribute value for both tables, item attribute values and item attribute value mapping 
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="attribute">Attribute id</param>
    /// <returns></returns>
    procedure DeleteItemAttributeValue(item: Text; attribute: Integer): Text
    var
        ItemAttrMapping: Record "Item Attribute Value Mapping";
        ItemAttrValues: Record "Item Attribute Value";
        ItemAttrValueId: Integer;
    begin

        ItemAttrMapping."Table ID" := 27;
        ItemAttrMapping."No." := item;
        ItemAttrMapping."Item Attribute ID" := attribute;
        if not ItemAttrMapping.Find('=') then
            Error('Item attribute mapping not found');

        ItemAttrValueId := ItemAttrMapping."Item Attribute Value ID";

        ItemAttrMapping.Delete;

        ItemAttrValues."Attribute ID" := attribute;
        ItemAttrValues.ID := ItemAttrValueId;
        ItemAttrValues.Delete;

        exit('item attribute value deleted');
    end;

    /// <summary>
    /// Insert or update an attribute value
    /// </summary>
    /// <param name="item">Item number</param>
    /// <param name="attribute">Attribute code</param>
    /// <param name="val">Value to setup</param>
    /// <returns></returns>
    procedure UpsertItemAttributeValue(item: Text; attribute: Text; val: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrMapping: Record "Item Attribute Value Mapping";
    begin

        ItemAttr.SetFilter(ItemAttr.Name, '%1', attribute);
        if not ItemAttr.FindFirst then
            Error('Item attribute not found');

        ItemAttrMapping."Table ID" := 27;
        ItemAttrMapping."No." := item;
        ItemAttrMapping."Item Attribute ID" := ItemAttr.ID;
        if ItemAttrMapping.Find('=') then
            ModifyAttributeValue(ItemAttr, ItemAttrMapping."Item Attribute Value ID", val)
        else
            InsertAttributeValue(item, ItemAttr, val);
    end;

}