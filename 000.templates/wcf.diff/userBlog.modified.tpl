{include file="documentHeader"}
<head>
	<title>{$user->username} - {lang}wcf.user.blog{/lang} - {lang}{PAGE_TITLE}{/lang}</title>
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
	
	<link rel="alternate" type="application/rss+xml" href="index.php?page=UserBlogFeed&amp;userID={@$userID}&amp;format=rss2" title="{lang}wcf.user.blog.feed{/lang} (RSS2)" />
	<link rel="alternate" type="application/atom+xml" href="index.php?page=UserBlogFeed&amp;userID={@$userID}&amp;format=atom" title="{lang}wcf.user.blog.feed{/lang} (Atom)" />
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
	<ul class="breadCrumbs">
		<li><a href="index.php?page=Index{@SID_ARG_2ND}"><img src="{icon}indexS.png{/icon}" alt="" /> <span>{lang}{PAGE_TITLE}{/lang}</span></a> &raquo;</li>
		<li><a href="index.php?page=UserBlogOverview{@SID_ARG_2ND}"><img src="{icon}blogS.png{/icon}" alt="" /> <span>{lang}wcf.user.blog{/lang}</span></a> &raquo;</li>
	</ul>

	<div class="mainHeadline">
		<img id="userEdit{@$userID}" src="{icon}blogL.png{/icon}" alt="" />
		<div class="headlineContainer">
			<h2><a href="index.php?page=UserBlog&amp;userID={@$user->userID}{@SID_ARG_2ND}">{lang}wcf.user.blog.entries.title{/lang}</a></h2>
		</div>
	</div>

	{if $userMessages|isset}{@$userMessages}{/if}
	{if $additionalMessages|isset}{@$additionalMessages}{/if}
	
	<div class="border blog">
		<div class="layout-2">
			<div class="columnContainer">
				<div class="container-1 column first">
					<div class="columnInner">
						<div class="contentBox">
							<h3 class="subHeadline">{if $tagID}{lang}wcf.user.blog.entries.tagged{/lang}{elseif $categoryID}{lang}wcf.user.blog.category.entries{/lang}{else if $filter == 'archive'}{lang}wcf.user.blog.archive.entries{/lang}{else}{lang}wcf.user.blog.entries.latestUpdates{/lang}{/if} <span>({#$items})</span></h3>
							
							{if !$entries|count}<p>{lang}wcf.user.blog.noEntries{/lang}</p>{/if}
								
							<div class="contentHeader">
								{pages print=true assign=pagesOutput link="index.php?page=UserBlog&userID=$userID&tagID=$tagID&categoryID=$categoryID&pageNo=%d"|concat:SID_ARG_2ND_NOT_ENCODED}
								
								{if ($userID == $this->user->userID && $this->user->getPermission('user.blog.canUseBlog')) || $additionalLargeButtons|isset}
									<div class="largeButtons">
										<ul>
											{if $userID == $this->user->userID && $this->user->getPermission('user.blog.canUseBlog')}<li><a href="index.php?form=UserBlogEntryAdd&amp;userID={@$userID}&amp;categoryID={@$categoryID}{@SID_ARG_2ND}#profileContent" title="{lang}wcf.user.blog.entry.add{/lang}"><img src="{icon}messageAddM.png{/icon}" alt="" /> <span>{lang}wcf.user.blog.entry.add{/lang}</span></a></li>{/if}
											
											{if $additionalLargeButtons|isset}{@$additionalLargeButtons}{/if}
										</ul>
									</div>
								{/if}
							</div>
							
							<div class="blogInner">
								{assign var='messageNumber' value=$items-$startIndex+1}
								{foreach from=$entries item=entry}
									{assign var="entryID" value=$entry->entryID}
									<div class="message blogArticle{if !$entry->isPublished} disabled{/if}">
										<div class="messageInner {cycle values='container-1,container-2'}">
											<a id="entry{@$entry->entryID}"></a>
											<div class="messageHeader">
												<p class="messageCount">
													<a href="index.php?page=UserBlogEntry&amp;entryID={@$entry->entryID}{@SID_ARG_2ND}#profileContent" title="{lang}wcf.user.blog.entry.permalink{/lang}" class="messageNumber">{#$messageNumber}</a>
												</p>
												
												<div class="containerIconLarge">
													{if $user->getAvatar()}
														<a href="index.php?page=User&amp;userID={@$user->userID}{@SID_ARG_2ND}" title="{lang username=$user->username}wcf.user.viewProfile{/lang}"><img src="{$user->getAvatar()->getURL()}" alt="" style="width: 48px; height: 48px" /></a>
													{else}
														<a href="index.php?page=User&amp;userID={@$user->userID}{@SID_ARG_2ND}" title="{lang username=$user->username}wcf.user.viewProfile{/lang}"><img src="{@RELATIVE_WCF_DIR}images/avatars/avatar-default.png" alt="" style="width: 48px; height: 48px" /></a>
													{/if}
												</div>
												<div class="containerContentLarge">
													<h4{if $entry->isEditable()} class="blogArticleTitle" id="userBlogEntryTitle{@$entry->entryID}"{/if}><a href="index.php?page=UserBlogEntry&amp;entryID={@$entry->entryID}{@SID_ARG_2ND}#profileContent">{$entry->subject}</a></h4>
													<div>
														{if $entry->isPrivate}<img src="{icon}forbiddenS.png{/icon}" class="isPrivate" title="{lang}wcf.user.blog.entry.isPrivate.title{/lang}" alt="" />{/if}
														
														{if USER_BLOG_ENABLE_RATING}<p class="rating light smallFont"> <span>{@$entry->getRatingOutput()}</span></p>{/if}
														
														<p class="light smallFont">{if $entry->publishingDate}{lang}wcf.user.blog.entry.publicationDate{/lang}{else}{@$entry->time|time}{/if}</p>
													</div>
												</div>
											</div>
											
											<div class="messageBody">
												{@$entry->getExcerpt()}
											</div>
											<hr />
											
											<div class="editNote smallFont light">
												<!-- Private Article -->
												{if $entry->isPrivate}<p>{lang}wcf.user.blog.entry.isPrivate.title{/lang}</p>{/if}
												
												<!-- Visits -->
												<p>{lang}wcf.user.blog.entry.visits{/lang}</p>
												
												{if $tags[$entryID]|isset}
													<!-- Tags -->
													<h4 class="hidden">{lang}wcf.user.blog.entry.tags{/lang}</h4>
													<p>{lang}wcf.user.blog.entry.tags{/lang}: {implode from=$tags[$entryID] item=entryTag}<a href="index.php?page=UserBlog&amp;userID={@$userID}&amp;tagID={@$entryTag->getID()}{@SID_ARG_2ND}#profileContent">{$entryTag->getName()}</a>{/implode}</p>
												{/if}
												
												{if $categories[$entryID]|isset}
													<!-- Categories -->
													<h4 class="hidden">{lang}wcf.user.blog.entry.categories{/lang}</h4>
													<p>{lang}wcf.user.blog.entry.categories{/lang}: {implode from=$categories[$entryID] item=entryCategory}<a href="{if $entryCategory->userID == 0}index.php?page=UserBlogOverview&amp;categoryID={@$entryCategory->categoryID}{@SID_ARG_2ND}{else}index.php?page=UserBlog&amp;userID={@$userID}&amp;categoryID={@$entryCategory->categoryID}{@SID_ARG_2ND}#profileContent{/if}">{if $entryCategory->userID == 0}{lang}{$entryCategory->title}{/lang}{else}{$entryCategory->title}{/if}</a>{/implode}</p>
												{/if}
											</div>
											
											<div class="messageFooter">
												<div class="smallButtons">
													<ul>
														<li class="extraButton"><a href="#top" title="{lang}wcf.global.scrollUp{/lang}"><img src="{icon}upS.png{/icon}" alt="" /> <span class="hidden">{lang}wcf.global.scrollUp{/lang}</span></a></li>
														{if $entry->isEditable()}<li><a href="index.php?form=UserBlogEntryEdit&amp;entryID={@$entry->entryID}{@SID_ARG_2ND}" title="{lang}wcf.user.blog.entry.edit{/lang}"><img src="{icon}editS.png{/icon}" alt="" /> <span>{lang}wcf.global.button.edit{/lang}</span></a></li>{/if}
														{if $entry->isDeletable()}<li><a href="index.php?action=UserBlogEntryDelete&amp;entryID={@$entry->entryID}&amp;t={@SECURITY_TOKEN}{@SID_ARG_2ND}" onclick="return confirm('{lang}wcf.user.blog.entry.delete.sure{/lang}')" title="{lang}wcf.user.blog.entry.delete{/lang}"><img src="{icon}deleteS.png{/icon}" alt="" /> <span>{lang}wcf.global.button.delete{/lang}</span></a></li>{/if}
														<li><a href="index.php?page=UserBlogEntry&amp;entryID={@$entry->entryID}{@SID_ARG_2ND}#comments" title="{lang}wcf.user.blog.entry.numberOfComments{/lang}"><img src="{icon}messageS.png{/icon}" alt="" /> <span>{lang}wcf.user.blog.entry.numberOfComments{/lang}</span></a></li>
														{if $entry->hasMoreText}<li><a href="index.php?page=UserBlogEntry&amp;entryID={@$entry->entryID}{@SID_ARG_2ND}#profileContent" title="{lang}wcf.user.blog.entry.more{/lang}"><img src="{icon}blogReadMoreS.png{/icon}" alt="" /> <span>{lang}wcf.user.blog.entry.more{/lang}</span></a></li>{/if}
														
														{if $additionalSmallButtons[$entry->entryID]|isset}{@$additionalSmallButtons[$entry->entryID]}{/if}
													</ul>
												</div>
											</div>
											<hr />
										</div>
									</div>
									{if $entry->isEditable()}
										<script type="text/javascript">
											//<![CDATA[
											userBlogEntryIDs.push({@$entry->entryID});
											//]]>
										</script>
									{/if}
									{assign var='messageNumber' value=$messageNumber-1}
								{/foreach}
							</div>
							
							{if $entries|count > 0}
								<div class="contentFooter">
									{@$pagesOutput}
									
									{if ($userID == $this->user->userID && $this->user->getPermission('user.blog.canUseBlog')) || $additionalLargeButtons|isset}
										<div class="largeButtons">
											<ul>
												{if $userID == $this->user->userID && $this->user->getPermission('user.blog.canUseBlog')}<li><a href="index.php?form=UserBlogEntryAdd&amp;userID={@$userID}&amp;categoryID={@$categoryID}{@SID_ARG_2ND}#profileContent" title="{lang}wcf.user.blog.entry.add{/lang}"><img src="{icon}messageAddM.png{/icon}" alt="" /> <span>{lang}wcf.user.blog.entry.add{/lang}</span></a></li>{/if}
												
												{if $additionalLargeButtons|isset}{@$additionalLargeButtons}{/if}
											</ul>
										</div>
									{/if}
								</div>
							{/if}
						</div>
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