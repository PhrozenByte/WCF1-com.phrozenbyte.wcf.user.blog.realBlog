{include file="documentHeader"}
<head>
	<title>{lang}wcf.user.blog.entry.{@$action}{/lang} - {lang}wcf.user.blog{/lang} - {lang}{PAGE_TITLE}{/lang}</title>
	
	{include file='headInclude' sandbox=false}
	
	{include file='imageViewer'}
	
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/TabbedPane.class.js"></script>
	<script type="text/javascript">
		//<![CDATA[
		var INLINE_IMAGE_MAX_WIDTH = {@INLINE_IMAGE_MAX_WIDTH}; 
		//]]>
	</script>
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/ImageResizer.class.js"></script>
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/Calendar.class.js"></script>
	<script type="text/javascript">
		//<![CDATA[
		var calendar = new Calendar('{$monthList}', '{$weekdayList}', {@$startOfWeek});
		
		document.observe('dom:loaded', function() {
			var checkbox = $('delayedPublishing');
			
			checkbox.observe('change', function() {
				if (checkbox.checked) {
					Effect.Appear('publicationDateDiv', { duration: 0.5 });
				}
				else {
					$('publicationDateDiv').hide();
					/*Effect.Fade('publicationDateDiv', { duration: 0.5 });*/
				}
			});
			
			var errorMessage = new Element('p').addClassName('innerError').hide();
			$('blogCategoryAddBarDiv').insert(errorMessage);
			
			$('addCategoryButton').observe('click', addCategory);
			$('categoryTitle').observe('keydown', function(event) {
				var keyCode = event.keyCode;
				
				if (keyCode == Event.KEY_RETURN) {
					addCategory(event);
				}
			});
			
			function addCategory(event) {
				var categoryTitle = $('categoryTitle').value.strip();
				
				if (categoryTitle != '') {
					new Ajax.Request('index.php?action=UserBlogCategoryAdd&t='+SECURITY_TOKEN+SID_ARG_2ND, {
						method: 'post',
						parameters: { categoryTitle: categoryTitle },
						onSuccess: function(transport) {
							var message = transport.responseText;
							
							// remove previous error message
							if (errorMessage.visible()) {
								$('blogCategoryAddBar').removeClassName('formError');
								errorMessage.hide();
							}
							
							if (message.startsWith('OK')) {
								var checkboxValue = message.split(':');
								var categoryID = parseInt(checkboxValue[1]);
								
								// create elements
								var input = new Element('input', { type: 'checkbox', name: 'categoryIDArray[]', value: categoryID, checked: 'checked' });
								var label = new Element('label').insert(input).insert(' '+categoryTitle);
								var listItem = new Element('li').addClassName('formField').insert(label).hide();
								
								// insert into container
								var categoryContainer = $('categoryContainer');
								categoryContainer.insert(listItem);
								
								// show parent element if hidden
								var parent = categoryContainer.up('div');
								if (parent.hasClassName('hidden')) {
									parent.appear({ duration: 0.5 }).removeClassName('hidden');
								}
								
								var placeholder = $('categoryPlaceholder');
								if (placeholder != undefined) {
									placeholder.remove();
								}
								
								listItem.appear({ duration: 0.5 });
								
								// remove text
								$('categoryTitle').value = '';
							}
							else {
								$('blogCategoryAddBar').addClassName('formError');
								errorMessage.update(message).show();
							}
						}
					});
				}
				else {
					$('blogCategoryAddBar').addClassName('formError');
					errorMessage.update('{lang}wcf.global.error.empty{/lang}').show();
				}
				
				event.stop();
			}
		});
		//]]>
	</script>
	{if $canUseBBCodes}{include file="wysiwyg"}{/if}
</head>
<body{if $templateName|isset} id="tpl{$templateName|ucfirst}"{/if}>
{* --- quick search controls --- *}
{assign var='searchFieldTitle' value='{lang}wcf.user.profile.search.query{/lang}'}
{capture assign=searchHiddenFields}
	<input type="hidden" name="userID" value="{@$user->userID}" />
{/capture}
{* --- end --- *}
{include file='header' sandbox=false}

<div id="main">
	{capture append='additionalMessages'}
		{if $errorField}
			<p class="error">{lang}wcf.global.form.error{/lang}</p>
		{/if}
	{/capture}
	
	{include file="userProfileHeader"}
	
	<form method="post" enctype="multipart/form-data" action="index.php?form=UserBlogEntry{@$action|ucfirst}{if $action == 'add'}&amp;userID={@$userID}{elseif $action == 'edit'}&amp;entryID={@$entryID}{/if}">
		<div class="border blog {if $this|method_exists:'getUserProfileMenu' && $this->getUserProfileMenu()->getMenuItems('')|count > 1}tabMenuContent{else}content{/if}">
			<div class="container-1">
				<h3 class="subHeadline">{lang}wcf.user.blog.entry.{@$action}{/lang}</h3>
				
				<div class="contentHeader">
					<div class="largeButtons">
						<ul>
							<li><a href="index.php?page=UserBlog&amp;userID={@$userID}{@SID_ARG_2ND}" title="{lang}wcf.user.blog{/lang}"><img src="{icon}blogM.png{/icon}" alt="" /> <span>{lang}wcf.user.blog{/lang}</span></a></li>
							
							{if $additionalLargeButtons|isset}{@$additionalLargeButtons}{/if}
						</ul>
					</div>
				</div>
				
				{if $preview|isset}
					<div class="message content">
						<div class="messageInner container-1">
							<div class="messageHeader">
								<h4>{lang}wcf.user.blog.entry.preview{/lang}</h4>
							</div>
							<div class="messageBody">
								<div>{@$preview}</div>
							</div>
						</div>
					</div>
				{/if}
				
				<fieldset>
					<legend>{lang}wcf.user.blog.entry.information{/lang}</legend>
					
					{if $availableContentLanguages|count > 1}
						<div class="formElement">
							<div class="formFieldLabel">
								<label for="languageID">{lang}wcf.user.language{/lang}</label>
							</div>
							<div class="formField">
								<select name="languageID" id="languageID">
									{foreach from=$availableContentLanguages key=langID item=language}
										<option label="{lang}wcf.global.language.{@$language.languageCode}{/lang}" value="{@$langID}"{if $langID == $languageID} selected="selected"{/if}>{lang}wcf.global.language.{@$language.languageCode}{/lang}</option>
									{/foreach}
								</select>
							</div>
						</div>
					{/if}
					
					<div class="formElement{if $errorField == 'subject'} formError{/if}">
						<div class="formFieldLabel">
							<label for="subject">{lang}wcf.user.blog.entry.subject{/lang}</label>
						</div>
						<div class="formField">
							<input type="text" class="inputText" name="subject" id="subject" value="{$subject}" tabindex="{counter name='tabindex'}" />
							{if $errorField == 'subject'}
								<p class="innerError">
									{if $errorType == 'empty'}{lang}wcf.global.error.empty{/lang}{/if}
								</p>
							{/if}
						</div>
					</div>
					
					{if $userID == $this->user->userID || $this->user->getPermission('mod.blog.canEditCategory')}
						<div class="formGroup">
							<div class="formGroupLabel">
								<label>{lang}wcf.user.blog.entry.categories{/lang}</label>
							</div>
							<div class="formGroupField">
								<fieldset>
									<legend>{lang}wcf.user.blog.entry.categories{/lang}</legend>
									<div class="floatContainer">
										{if $availableCategories.0|isset}
											<div class="floatTwoColumns">
												<p>{lang}wcf.user.blog.availableGlobalCategories{/lang}</p>
												<ol class="itemList">
													{foreach from=$availableCategories.0 item=availableCategory}
														<li class="formField">
															<label><input type="checkbox" name="categoryIDArray[]" value="{@$availableCategory->categoryID}" {if $categoryID == $availableCategory->categoryID || $availableCategory->categoryID|in_array:$categoryIDArray}checked="checked" {/if}/> {lang}{$availableCategory->title}{/lang}</label>
														</li>
													{/foreach}
												</ol>
											</div>
										{/if}
										<div class="floatTwoColumns{if !$availableCategories.$userID|isset} hidden{/if}" >
											<p>{lang}wcf.user.blog.categories.own{/lang}</p>
											<ol class="itemList" id="categoryContainer">
												{if $availableCategories.$userID|isset}
													{foreach from=$availableCategories.$userID item=availableCategory}
														<li class="formField">
															<label><input type="checkbox" name="categoryIDArray[]" value="{@$availableCategory->categoryID}" {if $categoryID == $availableCategory->categoryID || $availableCategory->categoryID|in_array:$categoryIDArray}checked="checked" {/if}/> {$availableCategory->title}</label>
														</li>
													{/foreach}
												{/if}
											</ol>
										</div>
									</div>
									
									{if !$availableCategories|count}<p class="formFieldDesc" id="categoryPlaceholder">{lang}wcf.user.blog.categories.none{/lang}</p>{/if}
									
									<div id="blogCategoryAddBar" class="formElement{if $errorField == 'categoryTitle'} formError{/if} buttonBar content">
										<div class="formFieldLabel">
											<label for="categoryTitle">{lang}wcf.user.blog.category.title{/lang}</label>
										</div>
										<div id="blogCategoryAddBarDiv" class="formField">
											<input type="text" id="categoryTitle" class="inputText" name="categoryTitle" value="{$categoryTitle}" tabindex="{counter name='tabindex'}" style="width: 50% !important;" />
											<input type="submit" name="send" value="{lang}wcf.global.button.submit{/lang}" class="hidden" />
											<input type="submit" id="addCategoryButton" name="addCategory" value="{lang}wcf.user.blog.category.add{/lang}" />
											{if $errorField == 'categoryTitle'}
												<p class="innerError">
													{if $errorType == 'empty'}{lang}wcf.global.error.empty{/lang}{/if}
													{if $errorType == 'notUnique'}{lang}wcf.user.blog.category.title.error.notUnique{/lang}{/if}
													{if $errorType == 'tooMuch'}{lang}wcf.user.blog.category.error.tooManyCategories{/lang}{/if}
												</p>
											{/if}
										</div>
									</div>
								</fieldset>
							</div>
						</div>
					{/if}
					
					{if MODULE_TAGGING}{include file='tagAddBit'}{/if}
					
					{if $additionalInformationFields|isset}{@$additionalInformationFields}{/if}
				</fieldset>
				
				{if !$enforceIsPrivate || $canDelayPublication}
					<fieldset>
						<legend>{lang}wcf.user.blog.entry.publication{/lang}</legend>
						
						{if !$enforceIsPrivate}
							<div class="formElement formCheckBox">
								<div class="formField">
									<label><input type="checkbox" name="isPrivate" id="isPrivat" value="1"{if $isPrivate} checked="checked"{/if} /> <span>{lang}wcf.user.blog.entry.isPrivate{/lang}</span></label>
								</div>
							</div>
						{/if}
						
						{if $canDelayPublication}
							<div class="formElement formCheckBox">
								<div class="formField">
									<label><input type="checkbox" name="delayedPublishing" id="delayedPublishing" value="1"{if $delayedPublishing} checked="checked"{/if} /> <span>{lang}wcf.user.blog.entry.delayedPublication{/lang}</span></label>
								</div>
							</div>
							
							<div id="publicationDateDiv" class="formGroup{if $errorField == 'publishingDate'} formError{/if}" style="{if !$delayedPublishing}display: none;{/if}">
								<div class="formGroupField">
									<fieldset>
										<div class="formField">
											<div class="floatedElement">
												<label for="publishingDay">{lang}wcf.global.date.day{/lang}</label>
												{htmlOptions options=$dayOptions selected=$selectedDate.day id=publishingDay name=publishingDay}
											</div>
											
											<div class="floatedElement">
												<label for="publishingMonth">{lang}wcf.global.date.month{/lang}</label>
												{htmlOptions options=$monthOptions selected=$selectedDate.month id=publishingMonth name=publishingMonth}
											</div>
											
											<div class="floatedElement">
												<label for="publishingYear">{lang}wcf.global.date.year{/lang}</label>
												<input id="publishingYear" class="inputText fourDigitInput" type="text" name="publishingYear" value="{@$selectedDate.year}" maxlength="4" />
											</div>
											
											<div class="floatedElement">
												<label for="publishingHour">{lang}wcf.global.date.hour{/lang}</label>
												<select name="publishingHour" id="publishingHour">
													<option></option>
													{section name=i start=1 loop=24}
														<option label="{@$i}" value="{@$i}"{if $selectedDate.hour == $i} selected="selected"{/if}>{@$i}</option>
													{/section}
												</select>
											</div>
											
											<div class="floatedElement">
												<a id="publishingButton"><img src="{icon}datePickerOptionsM.png{/icon}" alt="" /></a>
												<div id="publishingCalendar" class="inlineCalendar"></div>
												<script type="text/javascript">
													//<![CDATA[
													calendar.init('publishing');
													//]]>
												</script>
											</div>
										</div>
									</fieldset>
									{if $errorField == 'publishingDate'}
										<div class="formField">
											<p class="innerError">
												{if $errorType == 'past'}{lang}wcf.user.blog.entry.publicationDate.error.invalidDate{/lang}{/if}
											</p>
										</div>
									{/if}
								</div>
							</div>
						{/if}
					</fieldset>
				{/if}
				
				<fieldset>
					<legend>{lang}wcf.user.blog.entry.message{/lang}</legend>
					
					<div class="editorFrame formElement{if $errorField == 'text'} formError{/if}" id="textDiv">
						<div class="formFieldLabel">
							<label for="text">{lang}wcf.user.blog.entry.message{/lang}</label>
						</div>
						
						<div class="formField">				
							<textarea name="text" id="text" rows="15" cols="40" tabindex="{counter name='tabindex'}">{$text}</textarea>
							{if $errorField == 'text'}
								<p class="innerError">
									{if $errorType == 'empty'}{lang}wcf.global.error.empty{/lang}{/if}
									{if $errorType == 'tooLong'}{lang}wcf.message.error.tooLong{/lang}{/if}
									{if $errorType == 'censoredWordsFound'}{lang}wcf.message.error.censoredWordsFound{/lang}{/if}
								</p>
							{/if}
						</div>
						
					</div>
					
					{include file='messageFormTabs'}
				</fieldset>
				
				{if $additionalFields|isset}{@$additionalFields}{/if}
			</div>
		</div>
		
		<div class="formSubmit">
			<input type="submit" name="send" accesskey="s" value="{lang}wcf.global.button.submit{/lang}" tabindex="{counter name='tabindex'}" />
			<input type="submit" name="draft" accesskey="d" value="{lang}wcf.user.blog.button.saveAsDraft{/lang}" tabindex="{counter name='tabindex'}" />
			<input type="submit" name="preview" accesskey="p" value="{lang}wcf.global.button.preview{/lang}" tabindex="{counter name='tabindex'}" />
			<input type="reset" name="reset" accesskey="r" value="{lang}wcf.global.button.reset{/lang}" tabindex="{counter name='tabindex'}" />
			{@SID_INPUT_TAG}
			<input type="hidden" name="idHash" value="{$idHash}" />
		</div>
	</form>
	
	{if $insertQuotes == 1}
		<script type="text/javascript">
			//<![CDATA[
			document.observe("dom:loaded", function() {
				window.setTimeout(function() {
					multiQuoteManagerObj.insertParentQuotes('userBlogEntry', {@$userID});
					multiQuoteManagerObj.insertParentQuotes('userBlogEntryComment', {@$userID});
				}, 500);
			});
			//]]>
		</script>
	{/if}
</div>

{include file='footer' sandbox=false}
</body>
</html>