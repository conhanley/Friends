<ol>
<li>
<p>We are going to create a very simple Rails project called 'Friends' that will allow us to keep the contact information for our pals.  It should have only one model called <code>Friend</code>.  As a reminder, create the Rails app (<code>rails new Friends</code>) and use <code>rails generate scaffold</code> to create the model.  In terms of attributes, a friend should have a full name, nickname, email, phone, website and a friendship level.  (Remember to run <code>rake db:migrate</code> after creating the scaffolding and don't forget to save your code to your git repo.)  There are 4 friendship levels we will consider: 'Casual', 'Good', 'Close', 'Best'.  Do not make a friendship level model; these levels should be saved as an array in the Friend model as seen below:</p>

<div class="highlight highlight-ruby"><pre>  <span class="no">FRIENDSHIP_LEVELS</span> <span class="o">=</span> <span class="o">[</span> <span class="o">[</span><span class="s2">"Casual"</span><span class="p">,</span> <span class="mi">1</span><span class="o">]</span><span class="p">,</span> <span class="o">[</span><span class="s2">"Good"</span><span class="p">,</span> <span class="mi">2</span><span class="o">]</span><span class="p">,</span> <span class="o">[</span><span class="s2">"Close"</span><span class="p">,</span> <span class="mi">3</span><span class="o">]</span><span class="p">,</span> <span class="o">[</span><span class="s2">"Best"</span><span class="p">,</span> <span class="mi">4</span><span class="o">]</span> <span class="o">]</span>
</pre></div>
</li>
<li><p>Go to the form partial in the <code>app/views/friends</code> directory and make the friendship level a select list rather than a text field.   Now go to the <code>Friend</code> model to add a series of validations.  Make sure that the fields for name, email and level are required.  Using <code>validates_format_of</code>, make sure that the phone and email fields only take acceptable values for those attributes.  (Look back at the test arrays for regex lab if there is any doubt.)  Finally, the friendship level must be one of the 4 levels allowed; no tampering with the select list should be tolerated.  (If you are confident in your regex skills and have time, add another check that the website is valid.)  Have the TA verify that the basic project is working and all fields are validated appropriately.</p></li>
</ol>

<hr>

<h1>
<span class="mega-icon mega-icon-issue-opened"></span> Stop</h1>

<p>Show a TA that you have the Rails app set up and working as instructed and that the code is properly saved to git. Make sure the TA initials your sheet.</p>

<hr>

<ol>
<li>
<p>In this next step we are going to add a mailer so that our project can send an email every time we add a new friend to our list or delete one.  Switch to a new git branch before going further.  The first step is to set up an initializer with our SMTP settings.  We will use Yahoo Mail (Ymail) in this example, but you can use another service if you desire (Note: Google's security settings may prevent you from using Gmail).  Within the config/initializers directory, add a new file called <code>setup_mailer.rb</code> and insert the following code:</p>

<div class="highlight highlight-ruby"><pre>  <span class="no">ActionMailer</span><span class="o">::</span><span class="no">Base</span><span class="o">.</span><span class="n">smtp_settings</span> <span class="o">=</span> <span class="p">{</span>  
    <span class="ss">:address</span>              <span class="o">=&gt;</span> <span class="s2">"smtp.mail.yahoo.com"</span><span class="p">,</span>  
    <span class="ss">:port</span>                 <span class="o">=&gt;</span> <span class="mi">587</span><span class="p">,</span>  
    <span class="ss">:user_name</span>            <span class="o">=&gt;</span> <span class="s2">"&lt;your Yahoo email address&gt;"</span><span class="p">,</span>  
    <span class="ss">:password</span>             <span class="o">=&gt;</span> <span class="s2">"&lt;your Yahoo password&gt;"</span><span class="p">,</span>  
    <span class="ss">:authentication</span>       <span class="o">=&gt;</span> <span class="s2">"plain"</span><span class="p">,</span>  
    <span class="ss">:enable_starttls_auto</span> <span class="o">=&gt;</span> <span class="kp">true</span>  
  <span class="p">}</span>
</pre></div>

<p>Replace <code>&lt;your username&gt;</code> with your Ymail username, and <code>&lt;your password&gt;</code> with your Ymail password.</p>
</li>
<li>
<p>Now we want to create a mailer we can use to handle the business of sending mail.  We can create a basic mailer with the following code:</p>

<div class="highlight highlight-ruby"><pre>  <span class="n">rails</span> <span class="n">generate</span> <span class="n">mailer</span> <span class="no">FriendMailer</span>
</pre></div>

<p>This will create a new mailers directory with a new <code>friend_mailer.rb</code> model for us.  If you haven't saved the code to git yet, do so before we start adding our own code to the mailer.</p>
</li>
<li>
<p>In <code>application_mailer</code>, change the default <code>from</code> value to your full email address.  In <code>friend_mailer.rb</code>, create two methods: <code>new_friend_msg</code> and <code>remove_friend_msg</code>.  We will pass into the mailer a friend object so we will need to add that argument to each method.  Below is code that I used to set up my first method:</p>

<div class="highlight highlight-ruby"><pre>  <span class="k">def</span> <span class="nf">new_friend_msg</span><span class="p">(</span><span class="n">friend</span><span class="p">)</span>
    <span class="vi">@friend</span> <span class="o">=</span> <span class="n">friend</span>
    <span class="n">mail</span><span class="p">(</span><span class="ss">:to</span> <span class="o">=&gt;</span> <span class="n">friend</span><span class="o">.</span><span class="n">email</span><span class="p">,</span> <span class="ss">:subject</span> <span class="o">=&gt;</span> <span class="s2">"My New Friend"</span><span class="p">)</span>
<span class="k">end</span>
</pre></div>

<p>Adjust your code for both methods accordingly.</p>
</li>
<li><p>Now we need to create templates that these methods can call to generate an email body.  Going to the views directory, we see there is a subdirectory for friend_mailer; add two files: <code>new_friend_msg.text.erb</code> (for a regular text email) and <code>remove_friend_msg.html.erb</code> (for html-formatted email).  We need to be sure to pass in the name of our friend and display it using erb tags.  An example of appropriate templates can be found at the end of the lab; you will want to modify the actual text so that it sounds like it is from you.  (... unless you are also half-Klingon like me, in which case the example templates will work just fine.)</p></li>
<li>
<p>Finally, we have to actually send the mail.  There are several ways of doing this, but we will use the most direct.  Go into the <code>friends_controller.rb</code> file and look at the <code>create</code> method.  After the new friend is created (<code>if @friend.save</code>) add the following code:</p>

<div class="highlight highlight-ruby"><pre>  <span class="c1"># Provide an email confirmation if all is good...</span>
  <span class="no">FriendMailer</span><span class="o">.</span><span class="n">new_friend_msg</span><span class="p">(</span><span class="vi">@friend</span><span class="p">)</span><span class="o">.</span><span class="n">deliver</span>

  <span class="c1"># Now a page confirmation as well...</span>
  <span class="n">flash</span><span class="o">[</span><span class="ss">:notice</span><span class="o">]</span> <span class="o">=</span> <span class="s2">"</span><span class="si">#{</span><span class="vi">@friend</span><span class="o">.</span><span class="n">nickname</span><span class="si">}</span><span class="s2"> has been added as a friend and notified by email."</span>
</pre></div>

<p>The deliver method will call the new_friend_msg in the FriendMailer model and use the template (having the same name) to send an email to this friend.  Do something similar for the delete method so that a remove_friend_msg is sent when the friend is deleted.</p>
</li>
<li><p>Now time for a little testing.  Start up the server (if it's already running you need to restart to get the initializer file to be included) and add a new friend, but be sure to use your email. (Please do not spam anyone during this lab.)  Look at the server output (same window as <code>rails server</code> is running in) to see the email was sent.  Now delete that friend and verify the person was notified as well.  Merge all this back to the master branch and have a TA verify this and do the appropriate check-off.</p></li>
<li>
<p>You may have noticed that your email did not send ... oh dear. In order to remedy this and demonstrate the email generation, we will use the <a href="https://github.com/ryanb/letter_opener">letter opener gem</a> to save our emails to our app locally. First add the gem to your development environment and run the <code>bundle</code> command to install it.</p>

<div class="highlight highlight-ruby"><pre>   <span class="n">gem</span> <span class="s2">"letter_opener"</span>
</pre></div>

<p>Then set the delivery method in <code>config/environments/development.rb</code> to </p>

<div class="highlight highlight-ruby"><pre>  <span class="n">config</span><span class="o">.</span><span class="n">action_mailer</span><span class="o">.</span><span class="n">delivery_method</span> <span class="o">=</span> <span class="ss">:letter_opener</span>
</pre></div>

<p>Now any email will pop up in your browser instead of being sent. The messages are stored in <code>tmp/letter_opener</code>.</p>
</li>
</ol>

<hr>

<h1>
<span class="mega-icon mega-icon-issue-opened"></span> Stop</h1>

<p>Show a TA that you have the email functionality set up and working as instructed (email in your inbox or browser, either way is fine) and that the code is properly saved to git. Make sure the TA initials your sheet.</p>

<hr>

<ol>
<li><p>Now we want to be able to add a photo of our friends so that when we display their listing, a magnificent image appears.  Start by cutting a new branch in git called 'photos'.  To do the uploads we will use a gem known as <a href="https://github.com/jnicklas/carrierwave">CarrierWave</a>.  There are other gems that can also be used – <a href="https://github.com/thoughtbot/paperclip">paperclip</a> being one of the more popular ones – but carrierwave is easier to set up (IMHO) and works with <a href="http://api.rubyonrails.org/classes/ActiveRecord/Base.html">ActiveRecord</a>, <a href="http://datamapper.org/">DataMapper</a> and a variety of <a href="http://solnic.eu/2011/11/29/the-state-of-ruby-orm.html">ORMs</a>.  To get this gem installed, go to the Gemfile and type <code>gem 'carrierwave'</code> and then <code>bundle install</code> to add it to your system gems.</p></li>
<li>
<p>Once the plugin is installed, we can run its generator to add a photo attribute to the Friend model with the following line of code:</p>

<div class="highlight highlight-ruby"><pre>  <span class="n">rails</span> <span class="n">generate</span> <span class="n">uploader</span> <span class="n">photo</span>
</pre></div>

<p>This creates a new directory within app called uploaders and a file within that called  'photo_uploader.rb' which will handle the logic of uploading a file.  Open that file and you will see there are a lot of options commented out for us.  We will leave most of these alone right now (feel free to experiment later), but there is one option we want to uncomment: the <code>extension_whitelist</code>. (starts around line 38 or so) This will ensure that the files being uploaded are images; to allow any type of file to be uploaded is a huge security risk and checking the extension types is the least we can do to stop potential abuse of this functionality.</p>
</li>
<li>
<p>The uploader file will not be of much value unless we explicitly connect it to the Friends model and alter the database to record the file path.  First, go into the Friend model and add near the top of the Friend class the following:</p>

<div class="highlight highlight-ruby"><pre>  <span class="n">mount_uploader</span> <span class="ss">:photo</span><span class="p">,</span> <span class="no">PhotoUploader</span>
</pre></div>

<p>Once the uploader is associated with the Friend model, we will need a migration so the connection can be recorded.  On the command line, type the following:  </p>

<div class="highlight highlight-ruby"><pre>  <span class="n">rails</span> <span class="n">generate</span> <span class="n">migration</span> <span class="n">add_photo_to_friends</span> <span class="ss">photo</span><span class="p">:</span><span class="n">string</span>
</pre></div>

<p>Open up this migration and look at the fields that are being created by this operation.  Run <code>rake db:migrate</code> to modify the database.</p>
</li>
<li><p>Make sure this parameter can be passed along by the controller to the model.  Go to the <code>friend_params</code> method in the controller and add :photo to the list of permitted parameters.</p></li>
<li>
<p>Now we have to go into the friend form partial and add a field that will allow a user to upload the image.  To start, at the top of the form after the <code>form_for @friend ...</code>  and before the <code>do ...</code>, add <code>:html =&gt; { :multipart =&gt; true }</code> so that the form is capable of receiving attachments (place a comma after <code>@friend</code> and get rid of any parentheses or it will produce an error).  Then go do into the form itself and add the following:</p>

<div class="highlight highlight-erb"><pre><span class="x">  &lt;div class="field"&gt;</span>
<span class="x">    </span><span class="cp">&lt;%=</span> <span class="n">form</span><span class="o">.</span><span class="n">label</span> <span class="ss">:photo</span> <span class="cp">%&gt;</span><span class="x">&lt;br /&gt;</span>
<span class="x">    </span><span class="cp">&lt;%=</span> <span class="n">form</span><span class="o">.</span><span class="n">file_field</span> <span class="ss">:photo</span> <span class="cp">%&gt;</span><span class="x"></span>
<span class="x">  &lt;/div&gt;</span>
</pre></div>

<p>This will create file upload control that will allow users to browse and select a photo to upload.</p>
</li>
<li>
<p>To display a photo that is uploaded, go to the 'show' page for friends and add this code somewhere on the page where it is appropriate:</p>

<div class="highlight highlight-erb"><pre><span class="x">  </span><span class="cp">&lt;%</span> <span class="k">unless</span> <span class="vi">@friend</span><span class="o">.</span><span class="n">photo_url</span><span class="o">.</span><span class="n">nil?</span> <span class="cp">%&gt;</span><span class="x"></span>
<span class="x">    &lt;p&gt;</span><span class="cp">&lt;%=</span> <span class="n">image_tag</span> <span class="vi">@friend</span><span class="o">.</span><span class="n">photo_url</span> <span class="cp">%&gt;</span><span class="x">&lt;/p&gt;</span>
<span class="x">  </span><span class="cp">&lt;%</span> <span class="k">end</span> <span class="cp">%&gt;</span><span class="x"></span>
</pre></div>
</li>
<li><p>Once this in place, fire up the dev server again and add a photo for your friends.  If you need some appropriately sized photos, samples are available <a href="http://pawn.hss.cmu.edu/%7Eprofh/friends_pics.zip">here</a>.  (Warning: if you use these pictures, be sure to make <a href="http://www.youtube.com/watch?v=UYZoxY3sawE">Darth Vader</a> your friend.  Trust me, <a href="http://www.youtube.com/watch?v=81fwEmP2CKY">you don't want to hack off the Dark Lord of the Sith</a>.)  Make sure you save to git and merge back to the master branch.  Get the TA to sign off and you are done.</p></li>
</ol>

<hr>

<h1>
<span class="mega-icon mega-icon-issue-opened"></span> Stop</h1>

<p>Show a TA that you have the completed all portions of the lab, including file upload. Make sure the TA initials your sheet.</p>

<hr>

<p><strong>(Optional)</strong>: If you have time, you may consider modifying your application to persistently store files (in this lab, we did this locally, but on a full application you would want to use a cloud storage).  You can read more about how to integrate Carrierwave with Amazon S3 <a href="https://github.com/carrierwaveuploader/carrierwave">here</a>, scroll down to "Using Amazon S3". This is optional because the signup for S3 is a bit of a pain, but after that you can start uploading files with persistent storage for free (up to a certain limit).</p>

<h1>Template Samples</h1>

<p><strong>Example of new_friend_msg template:</strong></p>

<div class="highlight highlight-erb"><pre><span class="x">    nuqneH </span><span class="cp">&lt;%=</span> <span class="vi">@friend</span><span class="o">.</span><span class="n">nickname</span> <span class="cp">%&gt;</span><span class="x">,</span>

<span class="x">    I've just listed you as one of my friends.  I am sure you are deeply honored, as you should be.  </span>

<span class="x">    Remember the Klingon proverb regarding friends:</span>

<span class="x">       may'Daq jaHDI' SuvwI' juppu'Daj lonbe' </span>
<span class="x">       (When a warrior goes to a battle, he does not abandon his friends.)</span>

<span class="x">    Don't forget about me when you go into battle -- I will not forget you.</span>

<span class="x">    Qapla'</span>

<span class="x">    Klingon Code Warrior</span>
</pre></div>

<p><strong>Example of remove_friend_msg template:</strong></p>

<div class="highlight highlight-erb"><pre><span class="x">    &lt;p&gt;</span><span class="cp">&lt;%=</span> <span class="vi">@friend</span><span class="o">.</span><span class="n">full_name</span> <span class="cp">%&gt;</span><span class="x">,&lt;/p&gt;</span>

<span class="x">    &lt;p&gt;I had previously listed you as a friend; however, I am reminded of the old Klingon proverb:&lt;br /&gt;</span>

<span class="x">      QaghmeylIj tIchID, yIyoH &lt;br /&gt;</span>
<span class="x">      &lt;em&gt;(Have the courage to admit your mistakes.)&lt;/em&gt;&lt;br /&gt;</span>
<span class="x">    &lt;/p&gt;</span>

<span class="x">    &lt;p&gt;Clearly it was a mistake to make you a friend.  I admit this error in judgment and hereby remove you from my friend list.&lt;/p&gt;</span>

<span class="x">    &lt;p&gt;Dajonlu'pa' bIHeghjaj*&lt;/p&gt;</span>

<span class="x">    &lt;p&gt;Klingon Code Warrior&lt;/p&gt;</span>
<span class="x">    &lt;hr /&gt;</span>
<span class="x">    &lt;p&gt;&lt;em&gt;*May you die before you are captured.&lt;/em&gt;&lt;/p&gt;</span>
</pre></div>
