codeunit 50100 "My Unbound Action API"
{
    procedure UpdateItemAttributeValue(item: Text; attribute: Integer; val: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrMapping: Record "Item Attribute Value Mapping";
        ItemAttrValues: Record "Item Attribute Value";
        VarNumber: Decimal;
        VarDate: Date;
    begin

        if not ItemAttr.Get(attribute) then
            Error('Item attribute not found');

        ItemAttrMapping."Table ID" := 27;
        ItemAttrMapping."No." := item;
        ItemAttrMapping."Item Attribute ID" := attribute;
        if not ItemAttrMapping.Find('=') then
            Error('Item attribute mapping not found', item, attribute);

        if not ItemAttrValues.Get(attribute, ItemAttrMapping."Item Attribute Value ID") then
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

        exit('item attribute updated');
    end;

    procedure InsertItemAttributeValue(item: Text; attribute: Integer; val: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrMapping: Record "Item Attribute Value Mapping";
        ItemAttrValues: Record "Item Attribute Value";
        VarNumber: Decimal;
        VarDate: Date;
    begin

        if not ItemAttr.Get(attribute) then
            Error('Item attribute not found');

        ItemAttrValues.Init;
        ItemAttrValues."Attribute ID" := attribute;
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
        ItemAttrMapping."Item Attribute ID" := attribute;
        ItemAttrMapping."Item Attribute Value ID" := ItemAttrValues.ID;
        ItemAttrMapping.Insert;

        exit('item attribute value inserted');
    end;

}