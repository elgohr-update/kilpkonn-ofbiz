<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#-- variable setup -->
<#assign productContentWrapper = productContentWrapper!>
<#assign price = priceMap!>
<#-- end variable setup -->

<#-- virtual product javascript -->
${virtualJavaScript!}
<script type="application/javascript">
  <!--
  var detailImageUrl = null;
  function setAddProductId(name) {
    document.addform.add_product_id.value = name;
    if (document.addform.quantity == null) return;
    if (name == 'NULL' || isVirtual(name) == true) {
      document.addform.quantity.disabled = true;
    } else {
      document.addform.quantity.disabled = false;
    }
  }
  function isVirtual(product) {
    var isVirtual = false;
  <#if virtualJavaScript??>
    for (i = 0; i < VIR.length; i++) {
      if (VIR[i] == product) {
        isVirtual = true;
      }
    }
  </#if>
    return isVirtual;
  }

  function addItem() {
    document.configform.action = document.addform.action;
    document.configform.quantity.value = document.addform.quantity.value;
    document.configform.submit();
  }
  function verifyConfig() {
    document.configform.submit();
  }

  function popupDetail() {
    var defaultDetailImage = "${firstDetailImage?default(mainDetailImageUrl?default("_NONE_"))}";
    if (defaultDetailImage == null || "null" == defaultDetailImage || "" == defaultDetailImage) {
      defaultDetailImage = "_NONE_";
    }

    if (detailImageUrl == null || "null" == detailImageUrl) {
      detailImageUrl = defaultDetailImage;
    }

    if ("_NONE_" == detailImageUrl) {
      hack = document.createElement('span');
      hack.innerHTML = "${uiLabelMap.CommonNoDetailImageAvailableToDisplay}";
      showErrorAlert("${uiLabelMap.CommonErrorMessage2}", "${uiLabelMap.CommonNoDetailImageAvailableToDisplay}");
      return;
    }
    detailImageUrl = detailImageUrl.replace(/\&\#47;/g, "/");
    popUp("<@ofbizUrl>detailImage?detail=" + detailImageUrl + "</@ofbizUrl>", 'detailImage', '400', '550');
  }

  function toggleAmt(toggle) {
    if (toggle == 'Y') {
      changeObjectVisibility("add_amount", "visible");
    }

    if (toggle == 'N') {
      changeObjectVisibility("add_amount", "hidden");
    }
  }

  function findIndex(name) {
    for (i = 0; i < OPT.length; i++) {
      if (OPT[i] == name) {
        return i;
      }
    }
    return -1;
  }

  function getList(name, index, src) {
    currentFeatureIndex = findIndex(name);

    if (currentFeatureIndex == 0) {
      // set the images for the first selection
      if (IMG[index] != null) {
        if (document.images['mainImage'] != null) {
          document.images['mainImage'].src = IMG[index];
          detailImageUrl = DET[index];
        }
      }

      // set the drop down index for swatch selection
      document.forms["addform"].elements[name].selectedIndex = (index * 1) + 1;
    }

    if (currentFeatureIndex < (OPT.length - 1)) {
      // eval the next list if there are more
      var selectedValue = document.forms["addform"].elements[name].options[(index * 1) + 1].value;
      eval("list" + OPT[(currentFeatureIndex + 1)] + selectedValue + "()");

      // set the product ID to NULL to trigger the alerts
      setAddProductId('NULL');
    } else {
      // this is the final selection -- locate the selected index of the last selection
      var indexSelected = document.forms["addform"].elements[name].selectedIndex;

      // using the selected index locate the sku
      var sku = document.forms["addform"].elements[name].options[indexSelected].value;

      // set the product ID
      setAddProductId(sku);

      // check for amount box
      toggleAmt(checkAmtReq(sku));
    }
  }
  //-->
</script>

<script type="application/javascript">
  <!--

  jQuery(document).ready(function () {
    jQuery('#configFormId').change(getConfigDetails)
  });

  function getConfigDetails(event) {
    jQuery.ajax({
      url: '<@ofbizUrl>getConfigDetailsEvent</@ofbizUrl>',
      type: 'POST',
      data: jQuery('#configFormId').serialize(),
      success: function (data) {
        var totalPrice = data.totalPrice;
        var configId = data.configId;
        document.getElementById('totalPrice').innerHTML = totalPrice;
        document.addToShoppingList.configId.value = configId;
        event.stop();
      }
    });
  }

  -->
</script>

<div id="productdetail" class="card">
  <table class="table table-responsive-sm">
  <#-- Category next/previous -->
  <#if category??>
    <tr>
      <td colspan="2" align="right">
        <#if previousProductId??>
          <a href='<@ofbizUrl>product/~category_id=${categoryId!}/~product_id=${previousProductId!}</@ofbizUrl>'
             class="buttontext">${uiLabelMap.CommonPrevious}</a>&nbsp;|&nbsp;
        </#if>
        <a href="<@ofbizUrl>category/~category_id=${categoryId!}</@ofbizUrl>" class="buttontext">
        ${(category.categoryName)?default(category.description)!}
        </a>
        <#if nextProductId??>&nbsp;|&nbsp;
          <a href='<@ofbizUrl>product/~category_id=${categoryId!}/~product_id=${nextProductId!}</@ofbizUrl>'
             class="buttontext">${uiLabelMap.CommonNext}</a>
        </#if>
      </td>
    </tr>
  </#if>
  <#-- Product image/name/price -->
    <tr>
      <td>
      <#assign productLargeImageUrl = productContentWrapper.get("LARGE_IMAGE_URL", "url")!>
      <#-- remove the next two lines to always display the virtual image first (virtual images must exist) -->
      <#if firstLargeImage?has_content>
        <#assign productLargeImageUrl = firstLargeImage>
      </#if>
      <#if productLargeImageUrl?string?has_content>
        <a href="javascript:popupDetail();">
          <img src='<@ofbizContentUrl>${contentPathPrefix!}${productLargeImageUrl!}</@ofbizContentUrl>' alt=""/>
        </a>
      </#if>
      </td>
      <td>
        <h2>${productContentWrapper.get("PRODUCT_NAME", "html")!}</h2>
        <div>${productContentWrapper.get("DESCRIPTION", "html")!}</div>
        <div><b>${product.productId!}</b></div>
      <#-- example of showing a certain type of feature with the product -->
      <#if sizeProductFeatureAndAppls?has_content>
        <div>
          <#if (sizeProductFeatureAndAppls?size == 1)>
          <#-- TODO : i18n -->
            Size:
          <#else>
            Sizes Available:
          </#if>
          <#list sizeProductFeatureAndAppls as sizeProductFeatureAndAppl>
          ${sizeProductFeatureAndAppl.description?default(sizeProductFeatureAndAppl.abbrev?default(
          sizeProductFeatureAndAppl.productFeatureId))}
            <#if sizeProductFeatureAndAppl_has_next>,</#if>
          </#list>
        </div>
      </#if>
      <#-- for prices:
              - if totalPrice is present, use it (totalPrice is the price calculated from the parts)
              - if price < competitivePrice, show competitive or "Compare At" price
              - if price < listPrice, show list price
              - if price < defaultPrice and defaultPrice < listPrice, show default
              - if isSale show price with salePrice style and print "On Sale!"
      -->
      <#if totalPrice??>
        <div>${uiLabelMap.ProductAggregatedPrice}:
          <span id='totalPrice' class='basePrice'>
            <@ofbizCurrency amount=totalPrice isoCode=totalPrice.currencyUsed/>
          </span>
        </div>
      <#else>
        <#if price.competitivePrice?? && price.price?? && price.price < price.competitivePrice>
          <div>${uiLabelMap.ProductCompareAtPrice}:
            <span class='basePrice'>
              <@ofbizCurrency amount=price.competitivePrice isoCode=price.currencyUsed/>
            </span>
          </div>
        </#if>
        <#if price.listPrice?? && price.price?? && price.price < price.listPrice>
          <div>${uiLabelMap.ProductListPrice}:
            <span class='basePrice'>
              <@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/>
            </span>
          </div>
        </#if>
        <#if price.listPrice?? && price.defaultPrice?? && price.price?? &&
        price.price < price.defaultPrice && price.defaultPrice < price.listPrice>
          <div>${uiLabelMap.ProductRegularPrice}:
            <span class='basePrice'>
              <@ofbizCurrency amount=price.defaultPrice isoCode=price.currencyUsed/>
            </span>
          </div>
        </#if>
        <div>
          <#if price.isSale?? && price.isSale>
            <span class='salePrice'>${uiLabelMap.OrderOnSale}!</span>
            <#assign priceStyle = "salePrice">
          <#else>
            <#assign priceStyle = "regularPrice">
          </#if>
        ${uiLabelMap.OrderYourPrice}:
          <#if "Y" = product.isVirtual!> from </#if>
            <span class='${priceStyle}'>
              <@ofbizCurrency amount=price.price isoCode=price.currencyUsed/>
            </span>
        </div>
        <#if price.listPrice?? && price.price?? && price.price < price.listPrice>
          <#assign priceSaved = price.listPrice - price.price>
          <#assign percentSaved = (priceSaved / price.listPrice) * 100>
          <div>${uiLabelMap.OrderSave}:
            <span class="basePrice">
              <@ofbizCurrency amount=priceSaved isoCode=price.currencyUsed/> (${percentSaved?int}%)
            </span>
          </div>
        </#if>
      </#if>
      <#-- Included quantities/pieces -->
      <#if product.quantityIncluded?? && product.quantityIncluded != 0>
        <div>
          ${uiLabelMap.OrderIncludes}:${product.quantityIncluded!}${product.quantityUomId!}
        </div>
      </#if>
      <#if product.piecesIncluded?? && product.piecesIncluded?long != 0>
        <div>
          ${uiLabelMap.OrderPieces}:${product.piecesIncluded}
        </div>
      </#if>
      <#if daysToShip??>
        <div>
          ${uiLabelMap.ProductUsuallyShipsIn} ${daysToShip} ${uiLabelMap.CommonDays}
        </div>
      </#if>

      <#-- show tell a friend details only in ecommerce application -->
        <div>&nbsp;</div>
        <div>
          <a href="javascript:popUpSmall('<@ofbizUrl>tellafriend?productId=${product.productId}</@ofbizUrl>','tellafriend');">${uiLabelMap.CommonTellAFriend}</a>
        </div>

      <#if disFeatureList?? && 0 < disFeatureList.size()>
        <p>&nbsp;</p>
        <#list disFeatureList as currentFeature>
          <div>
          ${currentFeature.productFeatureTypeId}:&nbsp;${currentFeature.description}
          </div>
        </#list>
        <div>&nbsp;</div>
      </#if>

        <form method="post"
            action="<@ofbizUrl>additem<#if requestAttributes._CURRENT_VIEW_??>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>"
            name="addform">
        <#assign inStock = true>
        <#-- Variant Selection -->
        <#if product.isVirtual?? && "Y" == product.isVirtual?upper_case>
          <#if variantTree?? && 0 < variantTree.size()>
            <#list featureSet as currentType>
              <div>
                <select name="FT${currentType}" onchange="javascript:getList(this.name, (this.selectedIndex-1), 1);">
                  <option>${featureTypes.get(currentType)}</option>
                </select>
              </div>
            </#list>
            <input type='hidden' name="product_id" value='${product.productId}'/>
            <input type='hidden' name="add_product_id" value='NULL'/>
          <#else>
            <input type='hidden' name="product_id" value='${product.productId}'/>
            <input type='hidden' name="add_product_id" value='NULL'/>
            <div class='tabletext'><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
            <#assign inStock = false>
          </#if>
        <#else>
          <input type='hidden' name="product_id" value='${product.productId}'/>
          <input type='hidden' name="add_product_id" value='${product.productId}'/>
          <#if productNotAvailable??>
            <#assign isStoreInventoryRequired =
            Static["org.apache.ofbiz.product.store.ProductStoreWorker"]
            .isStoreInventoryRequired(request, product)>
            <#if isStoreInventoryRequired>
              <div class='tabletext'><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
              <#assign inStock = false>
            <#else>
              <div class='tabletext'><b>${product.inventoryMessage!}</b></div>
            </#if>
          </#if>
        </#if>
      </td>
    </tr>
    <tr>
      <td>
      <#-- check to see if introductionDate hasn't passed yet -->
      <#if product.introductionDate?? && nowTimestamp.before(product.introductionDate)>
        <p>&nbsp;</p>
        <div class='tabletext' style='color: red;'>${uiLabelMap.ProductProductNotYetMadeAvailable}.</div>
      <#-- check to see if salesDiscontinuationDate has passed -->
      <#elseif product.salesDiscontinuationDate?? && nowTimestamp.after(product.salesDiscontinuationDate)>
        <div class='tabletext' style='color: red;'>${uiLabelMap.ProductProductNoLongerAvailable}.</div>
      <#-- check to see if the product requires inventory check and has inventory -->
      <#else>
        <#if inStock>
          <#if "Y" == product.requireAmount?default("N")>
            <#assign hiddenStyle = "visible">
          <#else>
            <#assign hiddenStyle = "hidden">
          </#if>
          <div id="add_amount" class="${hiddenStyle}">
            <label>Amount</label>
            <input type="text" size="5" class="form-control mb-2" name="add_amount" value=""/>
          </div>
          <#if !configwrapper.isCompleted()>
            <div>[${uiLabelMap.EcommerceProductNotConfigured}]&nbsp;
              <input type="text" size="5" name="quantity" value="0" disabled="disabled"/></div>
          <#else>
            <div class="input-group"><input type="text" size="5" name="quantity" value="1" class="form-control form-control-sm"/>
            <span class="input-group-button">
            <a href="javascript:addItem()" class="btn btn-outline-secondary btn-sm">
                  ${uiLabelMap.OrderAddToCart}
            </a>
            </span>
            </div>
            <#if minimumQuantity?? &&  minimumQuantity &gt; 0>
              Minimum order quantity is ${minimumQuantity}.
            </#if>
          </#if>
        </#if>
        <#if requestParameters.category_id??>
          <input type='hidden' name='category_id' value='${requestParameters.category_id}'/>
        </#if>
      </#if>
        </form>
        </td>
        </tr>
        <tr>
          <td>
            <#if sessionAttributes.userLogin?has_content && sessionAttributes.userLogin.userLoginId != "anonymous">
              <form name="addToShoppingList" method="post"
                    action="<@ofbizUrl>addItemToShoppingList<#if requestAttributes._CURRENT_VIEW_??>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>">
                <input type="hidden" name="productId" value="${product.productId}"/>
                <input type="hidden" name="product_id" value="${product.productId}"/>
                <input type="hidden" name="configId" value="${configId!}"/>
                <div class="row">
                  <div class="col-5">
                    <select name="shoppingListId" class="form-control form-control-sm">
                      <#if shoppingLists?has_content>
                        <#list shoppingLists as shoppingList>
                          <option value="${shoppingList.shoppingListId}">${shoppingList.listName}</option>
                        </#list>
                      </#if>
                      <option value="">---</option>
                      <option value="">${uiLabelMap.OrderNewShoppingList}</option>
                    </select>
                  </div>
                  <div class="col-5">
                    <input type="text" size="5" name="quantity" value="1" class="form-control form-control-sm"/>
                  </div>
                  <div class="col-2">
                    <a href="javascript:document.addToShoppingList.submit();" class="btn btn-outline-secondary btn-sm">
                      [${uiLabelMap.OrderAddToShoppingList}]
                    </a>
                  </div>
                </div>
              </form>
            <#else>
            ${uiLabelMap.OrderYouMust}
              <a href="<@ofbizUrl>checkLogin/showcart</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonBeLogged}</a>
            ${uiLabelMap.OrderToAddSelectedItemsToShoppingList}.&nbsp;
            </#if>
          </td>
        </tr>
        <tr>
        <td>
      <#-- Prefill first select box (virtual products only) -->
      <#if variantTree?? && 0 < variantTree.size()>
        <script type="application/javascript">eval("list" + "${featureOrderFirst}" + "()");</script>
      </#if>

      <#-- Swatches (virtual products only) -->
      <#if variantSample?? && 0 < variantSample.size()>
        <#assign imageKeys = variantSample.keySet()>
        <#assign imageMap = variantSample>
        <p>&nbsp;</p>
        <table class="table">
          <tr>
            <#assign maxIndex = 7>
            <#assign indexer = 0>
            <#list imageKeys as key>
              <#assign swatchProduct = imageMap.get(key)>
              <#if swatchProduct?has_content && indexer < maxIndex>
                <#assign imageUrl =
                Static["org.apache.ofbiz.product.product.ProductContentWrapper"]
                .getProductContentAsText(swatchProduct, "SMALL_IMAGE_URL", request, "url")!>
                <#if !imageUrl?string?has_content>
                  <#assign imageUrl = productContentWrapper.get("SMALL_IMAGE_URL", "url")!>
                </#if>
                <#if !imageUrl?string?has_content>
                  <#assign imageUrl = "/images/defaultImage.jpg">
                </#if>
                <td align="center" valign="bottom">
                  <a href="javascript:getList('FT${featureOrderFirst}','${indexer}',1);">
                    <img src="<@ofbizContentUrl>${contentPathPrefix!}${imageUrl}</@ofbizContentUrl>"
                         class='cssImgSmall' alt=""/>
                  </a>
                  <br/>
                  <a href="javascript:getList('FT${featureOrderFirst}','${indexer}',1);" class="buttontext">
                  ${key}
                  </a>
                </td>
              </#if>
              <#assign indexer = indexer + 1>
            </#list>
            <#if (indexer > maxIndex)>
              <div><b>${uiLabelMap.OrderMoreOptionsAvailable}.</b></div>
            </#if>
          </tr>
        </table>
      </#if>
      </td>
    </tr>
  <#-- Long description of product -->
  <#if productContentWrapper.get("LONG_DESCRIPTION", "html") != "">
    <tr>
      <td colspan="2">
        <div>${productContentWrapper.get("LONG_DESCRIPTION", "html")!}</div>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <hr class='sepbar'/>
      </td>
    </tr>
  </#if>
  <#-- Any attributes/etc may go here -->
  <#-- Product Configurator -->
    <tr>
      <td colspan="2">
        <form name="configform" id="configFormId" method="post"
              action="<@ofbizUrl>product<#if requestAttributes._CURRENT_VIEW_??>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>">
          <input type='hidden' name='add_product_id' value='${product.productId}'/>
          <input type='hidden' name='add_category_id' value=''/>
          <input type='hidden' name='quantity' value='1'/>

          <input type='hidden' name='product_id' value='${product.productId}'/>
          <table>
            <tr>
              <td>
                <div>
                  <a href="javascript:verifyConfig();" class="btn btn-outline-secondary btn-sm">${uiLabelMap.OrderVerifyConfiguration}</a>
                </div>
              </td>
            </tr>

          <#assign counter = 0>
          <#assign questions = configwrapper.questions>
          <#list questions as question>
            <tr>
              <td>
                <div>${question.question}</div>
                <#if question.isFirst()>
                  <a name='#${question.getConfigItem().getString("configItemId")}'></a>
                  <div>${StringUtil.wrapString(question.description!)}</div>
                  <#assign instructions = question.content.get("INSTRUCTIONS", "html")!>
                  <#if instructions?has_content && instructions != "">
                    <a href="javascript:showErrorAlert('${uiLabelMap.CommonErrorMessage2}','${instructions}');"
                    class="btn btn-outline-secondary btn-sm">Instructions</a>
                  </#if>
                  <#assign image = question.content.get("IMAGE_URL", "url")!>
                  <#if image?string?has_content>
                    <img src='<@ofbizContentUrl>${contentPathPrefix!}${image!}</@ofbizContentUrl>'
                         vspace='5' hspace='5' class='cssImgXLarge' align='left' alt=""/>
                  </#if>
                <#else>
                  <div>
                    <a href='#${question.getConfigItem().getString("configItemId")}' class="btn btn-outline-secondary btn-sm">Details</a>
                  </div>
                </#if>
              </td>
            </tr>
            <tr>
              <td>
                <#if question.isStandard()>
                <#-- Standard item: all the options are always included -->
                  <#assign options = question.options>
                  <#list options as option>
                    <div>${option.description} <#if !option.isAvailable()> (*)</#if></div>
                  </#list>
                <#else>
                  <#if question.isSingleChoice()>
                  <#-- Single choice question -->
                    <#assign options = question.options>
                    <#assign selectedOption = question.getSelected()!>
                    <#assign selectedPrice = 0.0>
                    <#if selectedOption?has_content>
                      <#assign selectedPrice = selectedOption.getPrice()>
                    </#if>
                  <#-- The single choice input can be implemented with radio buttons or a select field -->
                    <#if renderSingleChoiceWithRadioButtons?? && "Y" == renderSingleChoiceWithRadioButtons>
                    <#-- This is the radio button implementation -->
                      <#if !question.isMandatory()>
                        <div class="form-check">
                          <input type="radio" class="form-check-input" name='${counter}' value='<#if !question.isSelected()>checked</#if>'/>
                          <label>No option</label>
                        </div>
                      </#if>
                      <#assign optionCounter = 0>
                      <#list options as option>
                        <#assign componentCounter = 0>
                        <#if showOffsetPrice?? && "Y" == showOffsetPrice>
                          <#assign shownPrice = option.price - selectedPrice>
                        <#else>
                          <#assign shownPrice = option.price>
                        </#if>
                      <#-- Render virtual compoennts -->
                        <#if option.hasVirtualComponent()>
                          <div class="form-check">
                            <input type='radio' name='${counter}' class="form-check-input" id="${counter}_${optionCounter}"
                                   value='${optionCounter}'
                                   onclick="javascript:checkOptionVariants('${counter}_${optionCounter}');"/>
                            <label>${option.description} <#if !option.isAvailable()> (*)</#if>
                            <#assign components = option.getComponents()>
                            <#list components as component>
                              <#if (option.isVirtualComponent(component))>
                              ${setRequestAttribute("inlineProductId", component.productId)}
                              ${setRequestAttribute("inlineCounter", counter+ "_" +optionCounter + "_"+componentCounter)}
                              ${setRequestAttribute("addJavaScript", componentCounter)}
                              ${screens.render(inlineProductDetailScreen)}
                                <#assign componentCounter = componentCounter + 1>
                              </#if>
                            </#list>
                            </label>
                          </div>
                        <#else>
                          <div class="form-check">
                            <input type="radio" name='${counter}' class="form-check-input" value='${optionCounter}'
                                   <#if option.isSelected() || (!question.isSelected() && optionCounter == 0 && question.isMandatory())>checked="checked"</#if>/>
                          <label>${option.description}&nbsp;
                            <#if (shownPrice > 0)>+<@ofbizCurrency amount=shownPrice isoCode=price.currencyUsed/>
                              &nbsp;</#if>
                            <#if (shownPrice < 0)>-<@ofbizCurrency amount=(-1*shownPrice) isoCode=price.currencyUsed/>
                              &nbsp;</#if>
                            <#if !option.isAvailable()>(*)</#if>
                          </label>
                          </div>
                        </#if>
                        <#assign optionCounter = optionCounter + 1>
                      </#list>
                    <#else>
                    <#-- And this is the select box implementation -->
                      <select name='${counter}' class="form-control">
                        <#if !question.isMandatory()>
                          <option value=''>---</option>
                        </#if>
                        <#assign options = question.options>
                        <#assign optionCounter = 0>
                        <#list options as option>
                          <#if showOffsetPrice?? && "Y" == showOffsetPrice>
                            <#assign shownPrice = option.price - selectedPrice>
                          <#else>
                            <#assign shownPrice = option.price>
                          </#if>
                          <#if option.isSelected()>
                            <#assign optionCounter = optionCounter + 1>
                          </#if>
                          <option value='${optionCounter}' <#if option.isSelected()>selected="selected"</#if>>
                          ${option.description}&nbsp;
                            <#if (shownPrice > 0)>+<@ofbizCurrency amount=shownPrice isoCode=price.currencyUsed/>
                              &nbsp;</#if>
                            <#if (shownPrice < 0)>-<@ofbizCurrency amount=(-1*shownPrice) isoCode=price.currencyUsed/>
                              &nbsp;</#if>
                            <#if !option.isAvailable()> (*)</#if>
                          </option>
                          <#assign optionCounter = optionCounter + 1>
                        </#list>
                      </select>
                    </#if>
                  <#else>
                  <#-- Multi choice question -->
                    <#assign options = question.options>
                    <#assign optionCounter = 0>
                    <#list options as option>
                      <#assign componentCounter = 0>
                    <#-- Render virtual compoennts -->
                      <#if option.hasVirtualComponent()>
                        <div class="form-check">
                          <input type='CHECKBOX' name='${counter}' class="form-check-input" id="${counter}_${optionCounter}"
                                 value='${optionCounter}'
                                 onclick="javascript:checkOptionVariants('${counter}_${optionCounter}');"/>
                          <label>${option.description} <#if !option.isAvailable()> (*)</#if>
                          <#assign components = option.getComponents()>
                          <#list components as component>
                            <#if (option.isVirtualComponent(component))>
                            ${setRequestAttribute("inlineProductId", component.productId)}
                            ${setRequestAttribute("inlineCounter", counter+ "_" +optionCounter + "_"+componentCounter)}
                            ${setRequestAttribute("addJavaScript", componentCounter)}
                            ${screens.render(inlineProductDetailScreen)}
                              <#assign componentCounter = componentCounter + 1>
                            </#if>
                          </#list>
                          </label>
                        </div>
                      <#else>
                        <div class="form-check">
                          <input type='CHECKBOX' name='${counter}' class="form-check-input"
                                 value='${optionCounter}' <#if option.isSelected()>checked="checked"</#if>/>
                          <label>${option.description} +<@ofbizCurrency amount=option.price isoCode=price.currencyUsed/>
                          <#if !option.isAvailable()> (*)</#if>
                          </label>
                        </div>
                      </#if>
                      <#assign optionCounter = optionCounter + 1>
                    </#list>
                  </#if>
                </#if>
              </td>
            </tr>
            <#assign counter = counter + 1>
          </#list>
          </table>
        </form>
      </td>
    </tr>
  <#-- Product Reviews -->
    <#if productReviews?has_content>
    <tr>
      <td colspan="2">
        <div>${uiLabelMap.OrderCustomerReviews}:</div>
      <#if averageRating?? && (averageRating > 0) && numRatings?? && (numRatings > 1)>
        <div>${uiLabelMap.OrderAverageRating}: ${averageRating}
          <#if numRatings??>(${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})</#if>
        </div>
      </#if>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <hr class='sepbar'/>
      </td>
    </tr>
    <#list productReviews as productReview>
      <#assign postedUserLogin = productReview.getRelatedOne("UserLogin", false)>
      <#assign postedPerson = postedUserLogin.getRelatedOne("Person", false)!>
      <tr>
        <td colspan="2">
          <table border="0" cellpadding="0" cellspacing='0'>
            <tr>
              <td>
                <div>${uiLabelMap.CommonBy}:
                  <#if "Y" == productReview.postedAnonymous?default("N")>
                  ${uiLabelMap.OrderAnonymous}
                  <#else>
                  ${postedPerson.firstName} ${postedPerson.lastName}
                  </#if>
                </div>
              </td>
              <td>
                <div>${uiLabelMap.CommonOn}: ${productReview.postedDateTime!}</div>
              </td>
              <td>
                <div>${uiLabelMap.OrderRanking}: ${productReview.productRating!?string}</div>
              </td>
            </tr>
            <tr>
              <td colspan="3">
                <div>&nbsp;</div>
              </td>
            </tr>
            <tr>
              <td colspan="3">
                <div>${productReview.productReview!}</div>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </#list>
    <tr>
      <td colspan="2">
        <a href="<@ofbizUrl>reviewProduct?category_id=${categoryId!}&amp;product_id=${product.productId}</@ofbizUrl>"
           class="buttontext">${uiLabelMap.ProductReviewThisProduct}!</a>
      </td>
    </tr>
  <#else>
    <tr>
      <td colspan="2">
        <div>${uiLabelMap.ProductProductNotReviewedYet}.</div>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <a href="<@ofbizUrl>reviewProduct?category_id=${categoryId!}&amp;product_id=${product.productId}</@ofbizUrl>">${uiLabelMap.ProductBeTheFirstToReviewThisProduct}</a>
      </td>
    </tr>
  </table>
  </#if>

  <#-- Upgrades/Up-Sell/Cross-Sell -->
  <#macro associated assocProducts beforeName showName afterName formNamePrefix targetRequestName>
    <#local targetRequest = "product">
    <#if targetRequestName?has_content>
      <#local targetRequest = targetRequestName>
    </#if>
    <#if assocProducts?has_content>
      <tr>
        <td></td>
      </tr>
      <tr>
        <td colspan="2">
          <h2>${beforeName!}<#if "Y" == showName>${productContentWrapper.get("PRODUCT_NAME", "html")!}</#if>${afterName!}</h2>
        </td>
      </tr>

      <#list assocProducts as productAssoc>
        <tr>
          <td>
            <div>
              <a href='<@ofbizUrl>${targetRequest}/<#if categoryId??>~category_id=${categoryId}/</#if>~product_id=${productAssoc.productIdTo!}</@ofbizUrl>'
                 class="buttontext">
              ${productAssoc.productIdTo!}
              </a>
              - ${productAssoc.reason!}
            </div>
          </td>
        </tr>
      ${setRequestAttribute("optProductId", productAssoc.productIdTo)}
      ${setRequestAttribute("listIndex", listIndex)}
      ${setRequestAttribute("formNamePrefix", formNamePrefix)}
        <#if targetRequestName?has_content>
        ${setRequestAttribute("targetRequestName", targetRequestName)}
        </#if>
        <tr>
          <td>
          ${screens.render(productsummaryScreen)}
          </td>
        </tr>
        <#local listIndex = listIndex + 1>

      </#list>
    ${setRequestAttribute("optProductId", "")}
    ${setRequestAttribute("formNamePrefix", "")}
    ${setRequestAttribute("targetRequestName", "")}
    </#if>
  </#macro>
  <#assign productValue = product>
  <#assign listIndex = 1>
  ${setRequestAttribute("productValue", productValue)}

    <table class="table">
    <#-- obsolete -->
    <@associated assocProducts=obsoleteProducts beforeName="" showName="Y"
        afterName=" is made obsolete by these products:" formNamePrefix="obs" targetRequestName=""/>
    <#-- cross sell -->
    <@associated assocProducts=crossSellProducts beforeName="" showName="N"
        afterName="You might be interested in these as well:" formNamePrefix="cssl" targetRequestName="crosssell"/>
    <#-- up sell -->
    <@associated assocProducts=upSellProducts beforeName="Try these instead of " showName="Y" afterName=":"
        formNamePrefix="upsl" targetRequestName="upsell"/>
    <#-- obsolescence -->
    <@associated assocProducts=obsolenscenseProducts beforeName="" showName="Y"
        afterName=" makes these products obsolete:" formNamePrefix="obce" targetRequestName=""/>
    </table>

  <#-- special cross/up-sell area using commonFeatureResultIds (from common feature product search) -->
  <#if commonFeatureResultIds?has_content>
    <h2>Similar Products That Might Interest You...</h2>


    <#list commonFeatureResultIds as commonFeatureResultId>
      <div>
      ${setRequestAttribute("optProductId", commonFeatureResultId)}
        ${setRequestAttribute("listIndex", commonFeatureResultId_index)}
        ${setRequestAttribute("formNamePrefix", "cfeatcssl")}
        <#-- ${setRequestAttribute("targetRequestName", targetRequestName)} -->
        ${screens.render(productsummaryScreen)}
      </div>
      <#if commonFeatureResultId_has_next>
        <hr/>
      </#if>
    </#list>
  </#if>
</div>
