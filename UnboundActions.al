codeunit 50100 "My Unbound Action API"
{
    procedure Ping(): Text
    begin
        exit('Pong');
    end;

    procedure GetFirstCustomerName(): Text
    var
        Cust: Record Customer;
    begin
        Cust.FindFirst();
        exit(Cust.Name);
    end;

    procedure UpdateItemAttributeValue(item: Text; attribute: Integer; val: Text): Text
    var
        ItemAttrMapping: Record "Item Attribute Value Mapping";
        ItemAttrValues: Record "Item Attribute Value";
    begin
        ItemAttrMapping."Table ID" := 27;
        ItemAttrMapping."No." := item;
        ItemAttrMapping."Item Attribute ID" := attribute;
        if not ItemAttrMapping.Find('=') then
            Error('Item attribute mapping not found', item, attribute);

        if not ItemAttrValues.Get(attribute, ItemAttrMapping."Item Attribute Value ID") then
            Error('Item attribute value not found');

        ItemAttrValues.Value := val;
        ItemAttrValues.Modify;

        exit('item attribute updated');
    end;

}