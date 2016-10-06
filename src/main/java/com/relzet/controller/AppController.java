package com.relzet.controller;

import com.relzet.model.*;
import com.relzet.service.UserDocumentService;
import com.relzet.service.UserProfileService;
import com.relzet.service.UserService;
import com.relzet.util.FileValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.*;
import java.util.List;
import java.util.Locale;


@Controller
@RequestMapping("/")
@SessionAttributes("roles")
public class AppController {

	@Autowired
	UserService userService;

	@Autowired
	UserDocumentService userDocumentService;

	@Autowired
	UserProfileService userProfileService;
	
	@Autowired
	MessageSource messageSource;

	@Autowired
	PersistentTokenBasedRememberMeServices persistentTokenBasedRememberMeServices;
	
	@Autowired
	AuthenticationTrustResolver authenticationTrustResolver;

	@Autowired
	FileValidator fileValidator;

	@InitBinder("fileBucket")
	protected void initBinder(WebDataBinder binder) {
		binder.setValidator(fileValidator);
	}

	/**
	 * This constant defines location where will store user documents
	 */
	private static final String LOCATION = "D:/temp/";

	/**
	 * This method will list all existing users.
	 */
	@RequestMapping(value = {  "/list" }, method = RequestMethod.GET)
	public String listUsers(ModelMap model) {

		List<User> users = userService.findAllUsers();
		model.addAttribute("users", users);
		model.addAttribute("loggedinuser", getPrincipal());
		return "userslist";
	}

	/**
	 * This method will provide the medium to add a new user.
	 */
	@RequestMapping(value = { "/newuser" }, method = RequestMethod.GET)
	public String newUser(ModelMap model) {
		User user = new User();
		model.addAttribute("user", user);
		model.addAttribute("edit", false);
		model.addAttribute("loggedinuser", getPrincipal());
		return "registration";
	}

	/**
	 * This method will be called on form submission, handling POST request for
	 * saving user in database. It also validates the user input
	 */
	@RequestMapping(value = { "/newuser" }, method = RequestMethod.POST)
	public String saveUser(@Valid User user, BindingResult result,
			ModelMap model) {

		if (result.hasErrors()) {
			return "registration";
		}
		/*
		 * Below mentioned peace of code [if block] demonstrate how to fill custom errors outside the validation
		 * framework as well while still using internationalized messages.
		 */
		if(!userService.isUserSSOUnique(user.getId(), user.getSsoId())){
			FieldError ssoError =new FieldError("user","ssoId",messageSource.getMessage("non.unique.ssoId", new String[]{user.getSsoId()}, Locale.getDefault()));
		    result.addError(ssoError);
			return "registration";
		}
		userService.saveUser(user);
		userDocumentService.saveDocument(createRootFolder(user));
		return "redirect:/login";
	}


	/**
	 * This method will provide the medium to update an existing user.
	 */
	@RequestMapping(value = { "/edit-user-{ssoId}" }, method = RequestMethod.GET)
	public String editUser(@PathVariable String ssoId, ModelMap model) {
		User user = userService.findBySSO(ssoId);
		model.addAttribute("user", user);
		model.addAttribute("edit", true);
		model.addAttribute("loggedinuser", getPrincipal());
		return "registration";
	}
	
	/**
	 * This method will be called on form submission, handling POST request for
	 * updating user in database. It also validates the user input
	 */
	@RequestMapping(value = { "/edit-user-{ssoId}" }, method = RequestMethod.POST)
	public String updateUser(@Valid User user, BindingResult result,
			ModelMap model, @PathVariable String ssoId) {

		if (result.hasErrors()) {
			return "registration";
		}

		userService.updateUser(user);

		return "redirect:/login";
	}

	
	/**
	 * This method will delete an user by it's SSOID value.
	 */
	@RequestMapping(value = { "/delete-user-{ssoId}" }, method = RequestMethod.GET)
	public String deleteUser(@PathVariable String ssoId) {
		userService.deleteUserBySSO(ssoId);
		return "redirect:/list";
	}
	

	/**
	 * This method will provide UserProfile list to views
	 */
	@ModelAttribute("roles")
	public List<UserProfile> initializeProfiles() {
		return userProfileService.findAll();
	}
	
	/**
	 * This method handles Access-Denied redirect.
	 */
	@RequestMapping(value = "/Access_Denied", method = RequestMethod.GET)
	public String accessDeniedPage(ModelMap model) {
		model.addAttribute("loggedinuser", getPrincipal());
		return "accessDenied";
	}

	/**
	 * This method handles login GET requests.
	 * If users is already logged-in and tries to goto login page again as a User role, will be redirected to the root folder view, else he will see list page
	 */
	@RequestMapping(value = {"/", "/login"}, method = RequestMethod.GET)
	public String loginPage() {
		if (isCurrentAuthenticationAnonymous()) {
			return "login";
	    } else if (isCurrentRoleUser()){
	    	return "redirect:/open-root-folder-"+userService.findBySSO(getPrincipal()).getId();
	    } else {
			return "redirect:/list";
		}
	}


	/**
	 * This method handles logout requests.
	 * Toggle the handlers if you are RememberMe functionality is useless in your app.
	 */
	@RequestMapping(value="/logout", method = RequestMethod.GET)
	public String logoutPage (HttpServletRequest request, HttpServletResponse response){
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null){
			persistentTokenBasedRememberMeServices.logout(request, response, auth);
			SecurityContextHolder.getContext().setAuthentication(null);
		}
		return "redirect:/login?logout";
	}

	/**
	* This method will provide the main (root) view of user's documents
	*/

	@RequestMapping(value = { "/open-root-folder-{userId}" }, method = RequestMethod.GET)
	public String openRootFolder(@PathVariable int userId, ModelMap model) {

		UserDocument doc = userDocumentService.findRootByUserId(userId);
		return "redirect:/open-folder-"+userId+"-"+doc.getId();
	}

	/**
	 * This method will provide a specific data populated view of selected folder
	 */

	@RequestMapping(value = { "/open-folder-{userId}-{docId}" }, method = RequestMethod.GET)
	public String openFolder(@PathVariable int userId, @PathVariable int docId, ModelMap model, @ModelAttribute("folderError") String folderError) throws IOException {

		User user = userService.findBySSO(getPrincipal());

		//	This if block gives ability to User with ADMIN authorities to change files and folders of other users
		if (isCurrentRoleAdmin())user = userService.findById(userId);

		model.addAttribute("user", user);

		//	This object (File Bucket) needs to be created, cause will be used in spring form on jsp view
		FileBucket fileModel = new FileBucket();
		model.addAttribute("fileBucket", fileModel);

		//	This object (Folder Bucket) needs to be created, cause will be used in spring form on jsp view
		FolderBucket folderBucket = new FolderBucket();
		model.addAttribute("folderBucket", folderBucket);

		// This attribute will show all user inner folders on the view
		List<UserDocument> folders = userDocumentService.findFoldersInFolder(user.getId(), docId);
		model.addAttribute("folders", folders);

		// This attribute will show all user files on the view
		List<UserDocument> documents = userDocumentService.findDocsInFolder(user.getId(), docId);
		model.addAttribute("documents", documents);

		//	This attribute added to Spring security needs on jsp view
		model.addAttribute("loggedinuser", getPrincipal());

		//	This attribute will populate morris-donut-chart widget on the view
		List<UserDocument> topFiles = userDocumentService.getTopFiles(user.getId());
		model.addAttribute("top", topFiles);

		//	This attribute will provide relation with a Controller in generating links
		UserDocument currentFolder = userDocumentService.findById(docId);
		model.addAttribute("currentFolder", currentFolder);

		// 	This attribute will show current folder directory on the view (substring is used to simplify large directory text)
		String directory = currentFolder.getDocumentLink();
		model.addAttribute("directory", directory.substring(directory.indexOf("ROOT")));

		// 	This attribute needs to generate Folder Up feature on the view (ternary operator disables a risk to exceed the scope of ROOT folder)
		int parentFolderId = currentFolder.getParentFolderId();
		model.addAttribute("parent_folder_id", parentFolderId==0?currentFolder.getId():parentFolderId);

		// This attribute will generate error text produced by wrong Folder name input
		model.addAttribute("folderError", folderError);

		return "managedocuments";

	}

	/**
	 * This method will provide a view with searched files and folders
	 */

	@RequestMapping(value = { "/search-{userId}-{docId}" }, method = RequestMethod.GET)
	public String search(@PathVariable int userId, @PathVariable int docId, @RequestParam("target") String target, ModelMap model) throws IOException {
		User user = userService.findById(userId);
		model.addAttribute("user", user);

		FileBucket fileModel = new FileBucket();
		model.addAttribute("fileBucket", fileModel);

		FolderBucket folderBucket = new FolderBucket();
		model.addAttribute("folderBucket", folderBucket);

		List<UserDocument> folders = userDocumentService.searchFoldersInFolder(userId, docId, target);
		model.addAttribute("folders", folders);

		List<UserDocument> documents = userDocumentService.searchDocsInFolder(userId, docId, target);
		model.addAttribute("documents", documents);

		model.addAttribute("currentFolder", userDocumentService.findById(docId));

		return "managedocuments";
	}


	/**
	 * This method will provide HTTP servlet response with data needed to download a file
	 */

	@RequestMapping(value = { "/download-document-{userId}-{docId}" }, method = RequestMethod.GET)
	public String downloadDocument(@PathVariable int userId, @PathVariable int docId, HttpServletResponse response) throws IOException {
		UserDocument document = userDocumentService.findById(docId);
		File file = new File(document.getDocumentLink());
		response.setContentType(document.getType());
		response.setContentLength((int) file.length());
		response.setHeader("Content-Disposition","attachment; filename=\"" + file.getName() +"\""); //download file

		InputStream inputStream = new BufferedInputStream(new FileInputStream(file));
		FileCopyUtils.copy(inputStream, response.getOutputStream());
		return "redirect:/open-root-folder-"+userId;
	}

	/**
	 * This method will provide HTTP servlet response with data needed to open a file immediately in a browser
	 */

	@RequestMapping(value = { "/preview-document-{userId}-{docId}" }, method = RequestMethod.GET)
	public String previewDocument(@PathVariable int userId, @PathVariable int docId, HttpServletResponse response) throws IOException {
		UserDocument document = userDocumentService.findById(docId);
		File file = new File(document.getDocumentLink());
		response.setContentType(document.getType());
		response.setContentLength((int) file.length());
		response.setHeader("Content-Disposition","inline; filename=\"" + file.getName() +"\""); //open file in browser

		InputStream inputStream = new BufferedInputStream(new FileInputStream(file));
		FileCopyUtils.copy(inputStream, response.getOutputStream());
		return "redirect:/open-root-folder-"+userId;
	}

	/**
	 * This method will provide a view with filtered files
	 */

	@RequestMapping(value = { "/filter-{userId}-{docId}" }, method = RequestMethod.GET)
	public String docsFilter(@PathVariable int userId, @RequestParam("filters") String[] filters, @PathVariable int docId, ModelMap model) throws IOException {
		User user = userService.findBySSO(getPrincipal());
		model.addAttribute("user", user);

		FileBucket fileModel = new FileBucket();
		model.addAttribute("fileBucket", fileModel);

		FolderBucket folderBucket = new FolderBucket();
		model.addAttribute("folderBucket", folderBucket);

		List<UserDocument> documents = userDocumentService.filterDocsInFolder(user.getId(), docId, filters);
		model.addAttribute("documents", documents);

		model.addAttribute("currentFolder", userDocumentService.findById(docId));

		return "managedocuments";

	}

	/**
	 * This method will delete chosen file from DB and file system
	 */

	@RequestMapping(value = { "/delete-document-{userId}-{docId}-{currentFolderId}" }, method = RequestMethod.GET)
	public String deleteDocument(@PathVariable int userId, @PathVariable int docId, @PathVariable int currentFolderId) {
		UserDocument document = userDocumentService.findById(docId);
		File file = new File(document.getDocumentLink());
		if (file.exists()) file.delete();

		userDocumentService.deleteById(docId, currentFolderId);
		return "redirect:/open-folder-"+userId+"-"+currentFolderId;

	}

	/**
	 * This method will delete chosen folder from DB and file system
	 */

	@RequestMapping(value = { "/delete-folder-{userId}-{docId}" }, method = RequestMethod.GET)
	public String deleteFolder(@PathVariable int userId, @PathVariable int docId) {
		File file = new File(userDocumentService.findById(docId).getDocumentLink());
		if (file.exists()) deleteDir(file);
		userDocumentService.deleteFolderById(docId);

		return "redirect:/open-root-folder-"+userId;
	}

	/**
	 * This method will save the uploaded file to file system and populate DB with file info, or will redirect user to Root folder if validation has errors
	 */

	@RequestMapping(value = { "/add-document-{userId}-{docId}" }, method = RequestMethod.POST)
	public String uploadDocument(@Valid FileBucket fileBucket, BindingResult result, ModelMap model, @PathVariable int userId, @PathVariable int docId) throws IOException{

		if (result.hasErrors()) {
			System.out.println("validation errors");
			User user = userService.findById(userId);
			model.addAttribute("user", user);

			List<UserDocument> documents = userDocumentService.findAllByUserId(userId);
			model.addAttribute("documents", documents);

			return "redirect:/open-root-folder-"+userId;
		} else {
			System.out.println("Fetching file");

			User user = userService.findById(userId);
			model.addAttribute("user", user);

			saveDocument(fileBucket, user, docId);

			return "redirect:/open-folder-"+userId+"-"+docId;
		}
	}

	/**
	 * This method will save the created folder, or show errors (like empty or Non unique Folder name ) on the view
	 */

	@RequestMapping(value = { "/create-folder-{userId}-{docId}" }, method = RequestMethod.POST)
	public String createFolder(@Valid FolderBucket folderBucket, BindingResult result, ModelMap model, @PathVariable int userId, @PathVariable int docId, RedirectAttributes redirectAttrs) throws IOException{
		String folderName = folderBucket.getFolderName();

		if (userDocumentService.checkFolderNameUnique(userId, docId, folderName)){
			redirectAttrs.addFlashAttribute("folderError", "Folder \""+folderName+"\" already exists");
			return "redirect:/open-folder-"+userId+"-"+docId;
		} else if(folderBucket.getFolderName().isEmpty()){
			redirectAttrs.addFlashAttribute("folderError", "Folder name cannot be empty");
			return "redirect:/open-folder-"+userId+"-"+docId;
		}

		User user = userService.findById(userId);
		model.addAttribute("user", user);

		userDocumentService.saveDocument(createFolder(user,folderName,docId));

		return "redirect:/open-folder-"+userId+"-"+docId;

	}



	/**
	 *  									SERVICE METHODS:
	 *
	 *


	 *
	 * This method will do all needed operations to save the uploaded file
	 */

	private void saveDocument(FileBucket fileBucket, User user, int docId) throws IOException{
        // initializing
		UserDocument document = new UserDocument();
		UserDocument folder = userDocumentService.findById(docId);
		MultipartFile multipartFile = fileBucket.getFile();

        // preparing file system to save a file
		File dirPath = new File(folder.getDocumentLink());
		if (!dirPath.exists()) {
			dirPath.mkdirs();
		}

        //setting up a document and folder info
		setUpGlyphicon(multipartFile, document);
        updateFolderInfo(folder, multipartFile);
		document.setName(multipartFile.getOriginalFilename());
		document.setParentFolderId(docId);
		document.setType(multipartFile.getContentType());
		document.setDocumentLink((dirPath + "/" + multipartFile.getOriginalFilename()));
		document.setUser(user);
		document.setSize((int)multipartFile.getSize()/1000);

        //saving a file to the file system
		multipartFile.transferTo(new File(dirPath.toString()+"/"+multipartFile.getOriginalFilename()));

        //updating a folder info and saving document to DB
		userDocumentService.updateDocument(folder);
		userDocumentService.saveDocument(document);
	}

    /**
     * This method will update Folder info: increments files counter and total size of inner files
     */
    private void updateFolderInfo(UserDocument folder, MultipartFile multipartFile) {
        folder.setSize(folder.getSize()+(int)multipartFile.getSize()/1000);
        folder.setFilesCounter(folder.getFilesCounter()+1);
    }

    /**
     * This method will create a Root folder for new User needs
     */
    private UserDocument createRootFolder(User user) {
		return new UserDocument(user, "ROOT", true, 0, LOCATION+user.getSsoId()+"/"+"ROOT"+"/");
	}

    /**
     * This method will create a new Folder with specific Folder Name
     */
	private UserDocument createFolder(User user , String folderName, int parentFolderId) {
		return new UserDocument(user, folderName, true, parentFolderId, userDocumentService.findById(parentFolderId).getDocumentLink()+folderName+"/");
	}

    /**
     * This method will set a specific Glyphicon (from Bootstrap collection) depend on file format
     */
    private void setUpGlyphicon(MultipartFile multipartFile, UserDocument document) {
        if (multipartFile.getContentType().contains("video")) document.setGlyphicon("-video-"); else
        if (multipartFile.getContentType().contains("image")) document.setGlyphicon("-picture-"); else
        if (multipartFile.getContentType().contains("audio")) document.setGlyphicon("-audio-"); else
        if (multipartFile.getContentType().contains("zip")) document.setGlyphicon("-zip-"); else
        if (multipartFile.getContentType().contains("pdf")) document.setGlyphicon("-pdf-"); else
        if (multipartFile.getContentType().contains("text")|| multipartFile.getContentType().contains("officedocument")||multipartFile.getContentType().contains("msword")) document.setGlyphicon("-text-"); else
            document.setGlyphicon("-");
    }

    /**
     * This method will recursively delete all files/folders in a Parameter directory
     */
    private void deleteDir(File file) {
		File[] contents = file.listFiles();
		if (contents != null) {
			for (File f : contents) {
				deleteDir(f);
			}
		}
		file.delete();
	}

	/**
	 * This method returns the principal[user-name] of logged-in user.
	 */
	private String getPrincipal(){
		String userName = null;
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

		if (principal instanceof UserDetails) {
			userName = ((UserDetails)principal).getUsername();
		} else {
			userName = principal.toString();
		}
		return userName;
	}
	
	/**
	 * This method returns true if users is already authenticated [logged-in], else false.
	 */
	private boolean isCurrentAuthenticationAnonymous() {
	    final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    return authenticationTrustResolver.isAnonymous(authentication);
	}

    /**
     * This method returns true if the authenticated user has a ROLE: 'USER", else false.
     */
	private boolean isCurrentRoleUser() {
		org.springframework.security.core.userdetails.User principal =
				(org.springframework.security.core.userdetails.User)
						SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			return principal.getAuthorities().iterator().next().getAuthority().equals("ROLE_USER");
	}

    /**
     * This method returns true if the authenticated user has a ROLE: 'ADMIN", else false.
     */
    private boolean isCurrentRoleAdmin() {
		org.springframework.security.core.userdetails.User principal =
				(org.springframework.security.core.userdetails.User)
						SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			return principal.getAuthorities().iterator().next().getAuthority().equals("ROLE_ADMIN");
	}



}