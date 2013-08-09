{include file="documentHeader"}
<head>
	<title>{$entry->subject} - {lang}wcf.user.blog{/lang} - {lang}{PAGE_TITLE}{/lang}</title>
	{include file='headInclude' sandbox=false}
	{include file='imageViewer'}
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/MultiPagesLinks.class.js"></script>
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/UserBlogEditor.class.js"></script>
	<script type="text/javascript">
		//<![CDATA[
		var INLINE_IMAGE_MAX_WIDTH = {@INLINE_IMAGE_MAX_WIDTH};
		var userBlogEntryIDs = new Array();
		
		document.observe('dom:loaded', function() {
			var userBlogEditor = new UserBlogEditor(userBlogEntryIDs);
		});
		//]]>
	</script>
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/ImageResizer.class.js"></script>
	{include file='multiQuote'}
	
	<link rel="stylesheet" type="text/css" media="screen" href="{@RELATIVE_WCF_DIR}style/userBlogRealBlog.css" />
	<style type="text/css">
		.blog .blogArticle .contentHeader {
			border-style: {$this->getStyle()->getVariable('divider.style')};
			border-width: 0 0 {$this->getStyle()->getVariable('divider.width')}{$this->getStyle()->getVariable('divider.width.unit')};
			border-color: {$this->getStyle()->getVariable('divider.color')};
		}
		
		.blog .userCardSidebar .userAvatar,
		.blog .userCardSidebar .userAvatarFramed,
		.blog .userCardSidebar .userSymbols {
			border-style: {$this->getStyle()->getVariable('divider.style')};
			border-width: {$this->getStyle()->getVariable('divider.width')}{$this->getStyle()->getVariable('divider.width.unit')} 0 0;
			border-color: {$this->getStyle()->getVariable('divider.color')};
		}
	</style>
</head>
<body{if $templateName|isset} id="tpl{$templateName|ucfirst}"{/if}>
{* --- quick search controls --- *}
{assign var='searchFieldTitle' value='{lang}wcf.user.blog.search.query{/lang}'}
{capture assign=searchHiddenFields}
	<input type="hidden" name="types[]" value="userBlogEntry" />
	<input type="hidden" name="userID" value="{@$user->userID}" />
{/capture}
{* --- end --- *}
{include file='header' sandbox=false}

<div id="main">
	{capture append='additionalMessages'}
		{if !$errorField|empty}
			<p class="error">{lang}wcf.global.form.error{/lang}</p>
		{/if}
	{/capture}
	
	<ul class="breadCrumbs">
		<li><a href="index.php?page=Index{@SID_ARG_2ND}"><img src="{icon}indexS.png{/icon}" alt="" /> <span>{lang}{PAGE_TITLE}{/lang}</span></a> &raquo;</li>
		<li><a href="index.php?page=UserBlogOverview{@SID_ARG_2ND}"><img src="{icon}blogS.png{/icon}" alt="" /> <span>{lang}wcf.user.blog{/lang}</span></a> &raquo;</li>
	</ul>

	<div class="mainHeadline">
		<img id="userEdit{@$userID}" src="{icon}blogL.png{/icon}" alt="" />
		<div class="headlineContainer">
			<h2><a href="index.php?page=UserBlogEntry&amp;entryID={@$entryID}{@SID_ARG_2ND}">{$entry->subject}</a></h2>
			{if USER_BLOG_ENABLE_RATING}<p id="ratingOutput{@$entry->entryID}">{@$entry->getRatingOutput()}</p>{/if}
		</div>
	</div>

	{if $userMessages|isset}{@$userMessages}{/if}
	{if $additionalMessages|isset}{@$additionalMessages}{/if}
	
	{if $entry->isCommentable()}{assign var=commentUsername value=$username}{/if}
	
	<div class="border blog">
		<div class="layout-2">
			<div class="columnContainer">
				<div class="container-1 column first">
					<div class="columnInner">
						<div class="contentBox blogArticle">
							<a id="entry{@$entry->entryID}"></a>
							
							{if $entry->isDraft}
								<p class="info">{lang}wcf.user.blog.entry.isDraft{/lang}</p>
							{else if !$entry->isPublished}
								<p class="info">{lang}wcf.user.blog.entry.publicationDate{/lang}</p>
							{/if}
							
							<div class="contentHeader">
								<p class="messageCount"><a href="index.php?page=UserBlogEntry&amp;entryID={@$entryID}#profileContent" title="{lang messageNumber=$entryID}wcf.user.blog.entry.permalink{/lang}" class="messageNumber">{#$entryID}</a></p>
								{if $entry->isPrivate}<img src="{icon}forbiddenS.png{/icon}" class="isPrivate" title="{lang}wcf.user.blog.entry.isPrivate.title{/lang}" alt="" />{/if}
								<p class="light firstPost">{@$entry->time|time}</p>
							</div>
							
							<div class="blogInner">
								<script type="text/javascript">
									//<![CDATA[
									quoteData.set('userBlogEntry-{@$entry->entryID}', {
										objectID: {@$entry->entryID},
										objectType: 'userBlogEntry',
										quotes: {@$entry->isQuoted()}
									});
									{if $entry->isEditable()}
										userBlogEntryIDs.push({@$entry->entryID});
									{/if}
									//]]>
								</script>
								
								<div class="messageBody" id="userBlogEntryText{@$entry->entryID}">
									{@$entry->getFormattedMessage()}
								</div>
								
								{include file='attachmentsShow' messageID=$entry->entryID author=$user}
								
								{assign var=linkedURLs value=$entry->getLinkedURLs()}
								{if $linkedURLs|count > 0}
									<div class="buttonBar">
										<h4 class="hidden">{lang}wcf.user.blog.entry.links{/lang}</h4>
										<ol>
											{foreach from=$linkedURLs item=linkedURL}
												<li><a href="{@$linkedURL.url}"{if $linkedURL.isExternal} class="externalURL"{/if}>{@$linkedURL.label}</a></li>
											{/foreach}
										</ol>
									</div>
								{/if}
								
								<div class="buttonBar">
									<!-- Private Articles -->
									{if $entry->isPrivate}<p class="light smallFont">{lang}wcf.user.blog.entry.isPrivate.title{/lang}</p>{/if}
									
									<!-- Visits -->
									<p class="light smallFont">{lang}wcf.user.blog.entry.visits{/lang}</p>
									
									{if $tags|count > 0}
										<!-- Tags -->
										<h4 class="hidden">{lang}wcf.user.blog.entry.tags{/lang}</h4>
										<p class="smallFont light">{lang}wcf.user.blog.entry.tags{/lang}: {implode from=$tags item=tag}<a href="index.php?page=UserBlog&amp;userID={@$userID}&amp;tagID={@$tag->getID()}{@SID_ARG_2ND}">{$tag->getName()}</a>{/implode}</p>
									{/if}
									
									{if $categories|count > 0}
										<!-- Categories -->
										<h4 class="hidden">{lang}wcf.user.blog.entry.categories{/lang}</h4>
										<p class="smallFont light">{lang}wcf.user.blog.entry.categories{/lang}: {implode from=$categories item=category}<a href="{if $category->userID == 0}index.php?page=UserBlogOverview&amp;categoryID={@$category->categoryID}{@SID_ARG_2ND}{else}index.php?page=UserBlog&amp;userID={@$userID}&amp;categoryID={@$category->categoryID}{@SID_ARG_2ND}#profileContent{/if}">{if $category->userID == 0}{lang}{$category->title}{/lang}{else}{$category->title}{/if}</a>{/implode}</p>
									{/if}
									
									{if $socialBookmarks|isset}
										<!-- Social Bookmarks -->
										{@$socialBookmarks}
									{/if}
									
									{if USER_BLOG_ENABLE_RATING && $this->user->getPermission('user.blog.canRateEntries')}
										<!-- Rating -->
										<div class="pageOptions rating">
											<span>{lang}wcf.user.blog.entry.rate{/lang}</span>
											{include file='objectRating'}
											<div id="com.woltlab.wcf.user.blog.entry-rating{@$entry->entryID}"></div>
											<noscript>
												<form method="post" action="index.php?action=ObjectRating{@SID_ARG_2ND}">
													<div>
														<select id="userBlogEntryRatingSelect" name="rating">
															{section name=i start=1 loop=6}
																<option value="{@$i}"{if $i == $rating->getUserRating()} selected="selected"{/if}>{@$i}</option>
															{/section}
														</select>
														<input type="hidden" name="objectName" value="com.woltlab.wcf.user.blog.entry" />
														<input type="hidden" name="objectID" value="{@$entryID}" />
														<input type="hidden" name="packageID" value="{@$objectPackageID}" />
														<input type="hidden" name="url" value="{'index.php?page=UserBlogEntry&entryID='|urlencode|concat:$entryID}" />
														<input type="image" class="inputImage" src="{icon}submitS.png{/icon}" alt="{lang}wcf.global.button.submit{/lang}" />
													</div>
												</form>
											</noscript>
											<script type="text/javascript">
												//<![CDATA[
												objectRatingObj.initializeObject({
													currentRating: {@$rating->getUserRating()},
													objectID: {@$entryID},
													objectName: 'com.woltlab.wcf.user.blog.entry',
													packageID: {@$objectPackageID}
												});
												//]]>
											</script>
										</div>
									{/if}
								</div>
								
								<div class="buttonBar">
									<div class="smallButtons">
										<ul id="userBlogEntryButtons{@$entry->entryID}">
											<li class="extraButton"><a href="#top" title="{lang}wcf.global.scrollUp{/lang}"><img src="{icon}upS.png{/icon}" alt="" /> <span class="hidden">{lang}wcf.global.scrollUp{/lang}</span></a></li>
											{if $entry->isEditable()}<li><a href="index.php?form=UserBlogEntryEdit&amp;entryID={@$entry->entryID}{@SID_ARG_2ND}" title="{lang}wcf.user.blog.entry.edit{/lang}"><img src="{icon}editS.png{/icon}" alt="" /> <span>{lang}wcf.global.button.edit{/lang}</span></a></li>{/if}
											{if MODULE_USER_INFRACTION == 1 && $this->user->getPermission('admin.user.infraction.canWarnUser')}
												<li><a href="index.php?form=UserWarn&amp;userID={@$entry->userID}&amp;objectType=userBlogEntry&amp;objectID={@$entry->entryID}{@SID_ARG_2ND}" title="{lang}wcf.user.infraction.button.warn{/lang}"><img src="{icon}infractionWarningS.png{/icon}" alt="" /> <span>{lang}wcf.user.infraction.button.warn{/lang}</span></a></li>
											{/if}
											{if $entry->isDeletable()}<li><a href="index.php?action=UserBlogEntryDelete&amp;entryID={@$entry->entryID}&amp;t={@SECURITY_TOKEN}{@SID_ARG_2ND}" onclick="return confirm('{lang}wcf.user.blog.entry.delete.sure{/lang}')" title="{lang}wcf.user.blog.entry.delete{/lang}"><img src="{icon}deleteS.png{/icon}" alt="" /> <span>{lang}wcf.global.button.delete{/lang}</span></a></li>{/if}
											
											{if $additionalSmallButtons|isset}{@$additionalSmallButtons}{/if}
										</ul>
									</div>
								</div>
								<hr />
								
								{* trackback / pingback *}
								{assign var=permalink value=PAGE_URL|concat:'/index.php?page=UserBlogEntry&entryID=':$entry->entryID}
								{@$trackback->getRdfAutoDiscover($entry->subject, $permalink, $entry->entryID, 'userBlogEntry', $objectPackageID)}
							</div>
						</div>
						
						<!-- Comments -->
						<a id="comments"></a>
						{if $comments|count > 0}
							<div class="contentBox">
								<h4 class="subHeadline">{lang}wcf.user.blog.entry.comments{/lang} <span>({#$items})</span></h4>
								
								<div class="contentHeader">
									{pages print=true assign=pagesOutput link="index.php?page=UserBlogEntry&entryID=$entryID&pageNo=%d#comments"|concat:SID_ARG_2ND_NOT_ENCODED}
								</div>
								
								<ul class="dataList messages">
									{assign var='messageNumber' value=$items-$startIndex+1}
									{foreach from=$comments item=commentObj}
										<li class="{cycle values='container-1,container-2'}">
											<a id="comment{@$commentObj->commentID}"></a>
											<div class="containerIcon">
												{if $commentObj->getUser()->getAvatar()}
													{assign var=x value=$commentObj->getUser()->getAvatar()->setMaxSize(24, 24)}
													{if $commentObj->userID}<a href="index.php?page=User&amp;userID={@$commentObj->userID}{@SID_ARG_2ND}" title="{lang username=$commentObj->username}wcf.user.viewProfile{/lang}">{/if}{@$commentObj->getUser()->getAvatar()}{if $commentObj->userID}</a>{/if}
												{else}
													{if $commentObj->userID}<a href="index.php?page=User&amp;userID={@$commentObj->userID}{@SID_ARG_2ND}" title="{lang username=$commentObj->username}wcf.user.viewProfile{/lang}">{/if}<img src="{@RELATIVE_WCF_DIR}images/avatars/avatar-default.png" alt="" style="width: 24px; height: 24px" />{if $commentObj->userID}</a>{/if}
												{/if}
											</div>
											<div class="containerContent">
												{if $action == 'edit' && $commentID == $commentObj->commentID}
													<form method="post" action="index.php?page=UserBlogEntry&amp;entryID={@$entryID}&amp;commentID={@$commentObj->commentID}&amp;action=edit">
														<div{if $errorField == 'comment'} class="formError"{/if}>
															<textarea name="comment" id="comment" rows="10" cols="40">{$comment}</textarea>
															{if $errorField == 'comment'}
																<p class="innerError">
																	{if $errorType == 'empty'}{lang}wcf.global.error.empty{/lang}{/if}
																	{if $errorType == 'tooLong'}{lang}wcf.user.blog.entry.comment.error.tooLong{/lang}{/if}
																</p>
															{/if}
														</div>
														<div class="formSubmit">
															<input type="submit" accesskey="s" value="{lang}wcf.global.button.submit{/lang}" />
															<input type="reset" accesskey="r" value="{lang}wcf.global.button.reset{/lang}" />
															
															{@SID_INPUT_TAG}
														</div>
													</form>
												{else}
													<div class="buttons">
														{if $commentObj->isEditable()}<a href="index.php?page=UserBlogEntry&amp;entryID={@$entryID}&amp;commentID={@$commentObj->commentID}&amp;action=edit{@SID_ARG_2ND}#comment{@$commentObj->commentID}" title="{lang}wcf.user.blog.entry.comment.edit{/lang}"><img src="{icon}editS.png{/icon}" alt="" /></a>{/if}
														{if $commentObj->isDeletable()}<a href="index.php?action=UserBlogEntryCommentDelete&amp;commentID={@$commentObj->commentID}&amp;t={@SECURITY_TOKEN}{@SID_ARG_2ND}" onclick="return confirm('{lang}wcf.user.blog.entry.comment.delete.sure{/lang}')" title="{lang}wcf.user.blog.entry.comment.delete{/lang}"><img src="{icon}deleteS.png{/icon}" alt="" /></a>{/if}
														<a href="index.php?page=UserBlogEntry&amp;entryID={@$entryID}&amp;commentID={@$commentObj->commentID}{@SID_ARG_2ND}#comment{@$commentObj->commentID}" title="{lang}wcf.user.blog.entry.comment.permalink{/lang}" class="messageNumber extraButton">{#$messageNumber}</a>
													</div>
													<p class="firstPost smallFont light">{lang}wcf.user.blog.entry.comment.by{/lang} {if $commentObj->userID}<a href="index.php?page=User&amp;userID={@$commentObj->userID}{@SID_ARG_2ND}">{$commentObj->username}</a>{else}{$commentObj->username}{/if} ({@$commentObj->time|time})</p>
													<p>{@$commentObj->getFormattedComment()}</p>
												{/if}
											</div>
										</li>
										{assign var='messageNumber' value=$messageNumber-1}
									{/foreach}
								</ul>
								
								<div class="contentFooter">
									{@$pagesOutput}
								</div>
								
								<div class="buttonBar">
									<div class="smallButtons">
										<ul>
											<li class="extraButton"><a href="#top" title="{lang}wcf.global.scrollUp{/lang}"><img src="{icon}upS.png{/icon}" alt="{lang}wcf.global.scrollUp{/lang}" /> <span class="hidden">{lang}wcf.global.scrollUp{/lang}</span></a></li>
										</ul>
									</div>
								</div>
							</div>
						{/if}
						
						<!-- Trackbacks -->
						{if $trackbacks|count > 0}
							<a id="trackbacks"></a>
							<div class="contentBox blogTrackbacks">
								<h3 class="subHeadline">{lang}wcf.user.blog.trackback.title{/lang} <span>({#$trackbacks|count})</span></h3>
								
								<ul class="dataList messages">
									{foreach from=$trackbacks item=trackbackEntry}
										<li class="{cycle name='className' values='container-1,container-2'}">
											<a id="trackback{@$trackbackEntry.trackbackID}"></a>
											<div class="containerIcon">
												<img src="{@RELATIVE_WCF_DIR}icon/blogTrackbackM.png" title="Trackback" alt="" />
											</div>
											<div class="containerContent">
												<p class="smallFont">{$trackbackEntry.applicationName}</p>
												<h4><a href="{$trackbackEntry.url}" title="wcf.user.blog.trackback.jumpToLinkedArticle">{$trackbackEntry.title}</a></h4>
												<p class="light smallFont">{@$trackbackEntry.time|time}</p>
												<p>{$trackbackEntry.excerpt}</p>
											</div>
										</li>
									{/foreach}
								</ul>
								
								<div class="buttonBar">
									<div class="smallButtons">
										<ul>
											<li class="extraButton"><a href="#top" title="{lang}wcf.global.scrollUp{/lang}"><img src="{icon}upS.png{/icon}" alt="{lang}wcf.global.scrollUp{/lang}" /> <span class="hidden">{lang}wcf.global.scrollUp{/lang}</span></a></li>
										</ul>
									</div>
								</div>
							</div>
						{/if}
						
						{if $entry->isCommentable() && $action != 'edit'}
							{assign var=username value=$commentUsername}
							<div class="contentBox blogComments">
								<form method="post" action="index.php?page=UserBlogEntry&amp;entryID={@$entryID}&amp;action=add">
									<fieldset>
										<legend>{lang}wcf.user.blog.entry.comment.add{/lang}</legend>
										
										{if !$this->user->userID}
											<div class="formElement{if $errorField == 'username'} formError{/if}">
												<div class="formFieldLabel">
													<label for="username">{lang}wcf.user.username{/lang}</label>
												</div>
												<div class="formField">
													<input type="text" class="inputText" name="username" id="username" value="{$username}" />
													{if $errorField == 'username'}
														<p class="innerError">
															{if $errorType == 'empty'}{lang}wcf.global.error.empty{/lang}{/if}
															{if $errorType == 'notValid'}{lang}wcf.user.error.username.notValid{/lang}{/if}
															{if $errorType == 'notAvailable'}{lang}wcf.user.error.username.notUnique{/lang}{/if}
														</p>
													{/if}
												</div>
											</div>
										{/if}
										
										<div class="formElement{if $errorField == 'comment' && $action == 'add'} formError{/if}">
											<div class="formFieldLabel">
												<label for="comment">{lang}wcf.user.blog.entry.comment{/lang}</label>
											</div>
											<div class="formField">
												<textarea name="comment" id="comment" rows="10" cols="40">{$comment}</textarea>
												{if $errorField == 'comment' && $action == 'add'}
													<p class="innerError">
														{if $errorType == 'empty'}{lang}wcf.global.error.empty{/lang}{/if}
														{if $errorType == 'tooLong'}{lang}wcf.user.blog.entry.comment.error.tooLong{/lang}{/if}
													</p>
												{/if}
											</div>
										</div>
										
										{include file='captcha' enableFieldset=false}
									</fieldset>
									
									<div class="formSubmit">
										<input type="submit" accesskey="s" value="{lang}wcf.global.button.submit{/lang}" />
										<input type="reset" accesskey="r" value="{lang}wcf.global.button.reset{/lang}" />
										
										{@SID_INPUT_TAG}
									</div>
								</form>
							</div>
							<hr />
						{/if}
						
						{if $additionalContent1|isset}{@$additionalContent1}{/if}
						
						<!-- Blog Article Navigation -->
						<a id="blogNavigation"></a>
						{if $nextEntry|isset || $previousEntry|isset}
							<div class="contentBox blogNavigation">
								<h3 class="subHeadline">{lang}wcf.user.blog.navigation.title{/lang}</h3>
								<div class="dataList">
									{if $nextEntry|isset}
										<div class="blogNavigationNext">
											<div class="containerIcon">
												<a href="index.php?page=UserBlogEntry&amp;entryID={@$nextEntry->entryID}{@SID_ARG_2ND}" title="{lang}wcf.user.blog.navigation.nextArticle{/lang}"><img src="{icon}nextM.png{/icon}" alt="" /></a>
											</div>
											<div class="containerContent">
												<p class="hidd en smallFont light">{lang}wcf.user.blog.navigation.nextArticle{/lang}</p> 
												<h4><a href="index.php?page=UserBlogEntry&amp;entryID={@$nextEntry->entryID}{@SID_ARG_2ND}" title="{$nextEntry->excerpt}">{$nextEntry->subject}</a></h4>
												<p class="light smallFont">{lang}wcf.user.blog.entry.by{/lang} <a href="index.php?page=User&amp;userID={@$userID}{@SID_ARG_2ND}">{$user->username}</a> ({@$nextEntry->time|time})</p>
											</div>
										</div>
									{/if}
									
									{if $previousEntry|isset}
										<div class="blogNavigationPrevious">
											<div class="containerIcon">
												<a href="index.php?page=UserBlogEntry&amp;entryID={@$previousEntry->entryID}{@SID_ARG_2ND}" title="{lang}wcf.user.blog.navigation.previousArticle{/lang}"><img src="{icon}previousM.png{/icon}" alt="" /></a>
											</div>
											<div class="containerContent">
												<p class="hidd en smallFont light">{lang}wcf.user.blog.navigation.previousArticle{/lang}</p> 
												<h4><a href="index.php?page=UserBlogEntry&amp;entryID={@$previousEntry->entryID}{@SID_ARG_2ND}" title="{$previousEntry->excerpt}">{$previousEntry->subject}</a></h4>
												<p class="light smallFont">{lang}wcf.user.blog.entry.by{/lang} <a href="index.php?page=User&amp;userID={@$userID}{@SID_ARG_2ND}">{$user->username}</a> ({@$previousEntry->time|time})</p>
											</div>
										</div>
									{/if}
								</div>
								<hr />
							</div>
						{/if}
						
						<div class="contentFooter"></div>
					</div>
				</div>
				
				{include file='userBlogSidebar'}
			</div>
		</div>
	</div>
</div>

{include file='footer' sandbox=false}
</body>
</html>
