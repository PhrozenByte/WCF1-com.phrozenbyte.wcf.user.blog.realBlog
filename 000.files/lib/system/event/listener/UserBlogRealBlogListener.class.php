<?php
require_once(WCF_DIR.'lib/system/event/EventListener.class.php');
require_once(WCF_DIR.'lib/page/util/menu/PageMenu.class.php');

/**
 * WoltLab Community Blog - Real Blog Modification Event Listener
 *
 * PHP version 5
 *
 * LICENSE:
 * WoltLab Community Blog - Real Blog Modification
 * Copyright (C) 2011  Daniel Rudolf <drudolf@phrozenbyte.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category 	Community Blog
 * @package		com.phrozenbyte.wcf.user.blog.realBlog
 * @subpackage	system.event.listener
 * @author		Daniel Rudolf
 * @copyright	2011 Daniel Rudolf
 * @license		GNU General Public License 3 or later <http://www.gnu.org/licenses/>
 * @link		http://www.phrozenbyte.de/
 * @version		1.0.0
 * @since		1.0.0
 */

/**
 * UserBlogRealBlogListener
 *
 * Sets blog page menu item as active on several user blog pages and
 * adds sidebar box containing user card if necessary
 *
 * This event listener is called by
 * UserBlogEntryAddForm::show
 * UserBlogEntryEditForm::show
 * UserBlogEntryPage::show
 * UserBlogPage::show
 * UserBlogEntryCommentAddForm::show
 * UserBlogEntryCommentEditForm::show
 *
 * @category 	Community Blog
 * @package		com.phrozenbyte.wcf.user.blog.realBlog
 * @subpackage	system.event.listener
 * @author		Daniel Rudolf
 * @copyright	2011 Daniel Rudolf
 * @license		GNU General Public License 3 or later <http://www.gnu.org/licenses/>
 * @link		http://www.phrozenbyte.de/
 * @version		1.0.0
 * @since		1.0.0
 */
class UserBlogRealBlogListener implements EventListener {
	/**
	 * @see EventListener::execute()
	 */
	public function execute($eventObj, $className, $eventName) {
		// set blog page menu item as active
		PageMenu::setActiveMenuItem('wcf.header.menu.user.blog');

		// add sidebar box containing user card (template 'userBlogSidebarUser')
		if(($className === 'UserBlogPage') || ($className === 'UserBlogEntryPage')) {
			$sidebarBoxes = WCF::getTPL()->get('sidebarBoxes');
			array_unshift($sidebarBoxes, 'userBlogSidebarUser');
			WCF::getTPL()->assign('sidebarBoxes', $sidebarBoxes);
		}
	}
}

?>
