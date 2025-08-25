module Locators
  # Ticket Page
  TICKET_PLUS_ICON        = 'svg#add-new-icon[aria-label="Add New"]'
  TICKET_OPTION           = "//div[@class='nav_new_details esm']/span[text()='Ticket']/ancestor::a"
  TICKET_SUBJECT_FIELD    = "input[name='ticket[subject]']"
  TICKET_DESCRIPTION      = "div.fr-element.fr-view[contenteditable='true']"
  WORKSPACE_DROPDOWN      = "//div[contains(@class,'ember-power-select-trigger')]//span[contains(text(),'Select workspace')]"
  WORKSPACE_OPTION        = "//ul[contains(@class,'ember-power-select-options')]//li//span[@class='ws-name ellipsis' and normalize-space(text())='%s']"
  REQUESTER_FIELD         = "//input[contains(@class,'ember-power-select-search-input') and @placeholder='Search']"
  SAVE_BUTTON             = "button[type='submit']"
  STATUS_DROPDOWN         = "//div[@formserv-field-name='status']//div[contains(@class,'ember-power-select-trigger')]"
  STATUS_OPTION           = "//li[contains(@class,'ember-power-select-option')][normalize-space(text())='%s']"
  UPDATE_BUTTON           = "#form-submit"

  # Admin / Change Form Page
  ADMIN_BTN               = "//a[contains(@class,'menu-tab') and contains(@class,'settings')]"
  WORKSPACE_SWITCHER      = "//button[@aria-label='Workspace']"
  WORKSPACE_OPTION_ADMIN  = "//a[contains(@class,'workspace-switcher-btn') and @data-name='%s']"
  FIELD_MANAGER           = "//div[contains(@class,'field-manager')]//span[text()='Field Manager']"
  CHANGE_FIELDS_BTN       = "//div[@class='new-card-item']//div[text()='Change Fields']/ancestor::a"
  CHANGE_CUSTOM_TEXT_FIELD = "//span[@class='ficon-sr_text dom-icon tooltip' and @data-original-title='Single Line Text']"
  CHANGE_CUSTOM_TEXT_LABEL = "//input[@name='custom-label']"
   CHANGE_FIELD_LABEL_VALUE = 'li[data-type="text"] span'
end
