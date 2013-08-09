{*
	WoltLab Community Blog - Real Blog Modification
	Copyright (C) 2011  Daniel Rudolf <drudolf@phrozenbyte.de>

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*}

<div class="userCardSidebar contentBox">
	<div class="userCardSidebarInner border">
		<ul class="userBlog dataList">
			<li class="userPersonals container-1">
				<p class="userName">
					{if MESSAGE_SIDEBAR_ENABLE_ONLINE_STATUS}
						{if $user->isOnline()}
							<img src="{icon}onlineS.png{/icon}" alt="" title="{lang username=$user->username}wcf.user.online{/lang}" />
						{else}
							<img src="{icon}offlineS.png{/icon}" alt="" title="{lang username=$user->username}wcf.user.offline{/lang}" />		
						{/if}
					{/if}
	
					<a href="index.php?page=User&amp;userID={@$user->userID}{@SID_ARG_2ND}" title="{lang username=$user->username}wcf.user.viewProfile{/lang}">
						<span>{$user->username}</span>
					</a>
		
					{if $additionalSidebarUsernameInformation|isset}{@$additionalSidebarUsernameInformation}{/if}
				</p>

				{if MODULE_USER_RANK && MESSAGE_SIDEBAR_ENABLE_RANK}
					{if $user->getUserTitle()}
						<p class="userTitle smallFont">{@$user->getUserTitle()}</p>
					{/if}
					{if $user->getRank() && $user->getRank()->rankImage}
						<p class="userRank">{@$user->getRank()->getImage()}</p>
					{/if}
				{/if}
	
				{if $additionalSidebarAuthorInformation|isset}{@$additionalSidebarAuthorInformation}{/if}
			</li>

			{if MESSAGE_SIDEBAR_ENABLE_AVATAR}
				{if $user->getAvatar()}
					<li class="userAvatar{if $this->getStyle()->getVariable('messages.sidebar.avatar.framed')}Framed{/if} container-1">
						<a href="index.php?page=User&amp;userID={@$user->userID}{@SID_ARG_2ND}" title="{lang username=$user->username}wcf.user.viewProfile{/lang}"><img src="{$user->getAvatar()->getURL()}" alt=""
							style="width: {@$user->getAvatar()->getWidth()}px; height: {@$user->getAvatar()->getHeight()}px;{if $this->getStyle()->getVariable('messages.sidebar.avatar.framed')} margin-top: -{@$user->getAvatar()->getHeight()/2|intval}px; margin-left: -{@$user->getAvatar()->getWidth()/2|intval}px{/if}" /></a>
					</li>
				{/if}
			{/if}

			{if $userSymbols|count > 0 || $additionalSidebarUserSymbols|isset}
				<li class="userSymbols container-1">
					<ul>
						{foreach from=$userSymbols item=$userSymbol}
							<li>{@$userSymbol}</li>
						{/foreach}
			
						{if $additionalSidebarUserSymbols|isset}{@$additionalSidebarUserSymbols}{/if}
					</ul>
				</li>
			{/if}
		
			{if $templateName != 'userBlog'}
				<li class="buttonBar">
					<div class="buttons">
						<a href="index.php?page=UserBlogFeed&amp;userID={@$user->userID}" title="{lang}wcf.user.blog.box.latestUpdates.rssFeed{/lang}" class="extraButton"><img src="{icon}rssFeedS.png{/icon}" alt="" /></a>
					</div>
					<h4 class="itemListTitle smallFont">
						<a href="index.php?page=UserBlog&amp;userID={@$user->userID}{@SID_ARG_2ND}">{lang}wcf.user.blog.entries.title{/lang}</a>
					</h4>
				</li>
			{/if}
		</ul>
	</div>
</div>
<hr/>
