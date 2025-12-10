<?xml version="1.0" encoding="UTF-8"?>

<!--
fo-two-column.xsl
Transform XML resume into XSL-FO, for formatting into PDF with a two-column layout.

Based on fo.xsl from the XMLResume project.

Copyright (c) 2000-2002 Sean Kelly
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$Id: fo.xsl,v 1.15 2002/11/10 20:48:58 brandondoyle Exp $
-->

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"
    encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="../params.xsl"/>
  <xsl:include href="../lib/common.xsl"/>
  <xsl:include href="../lib/string.xsl"/>

  <!-- Format the document. -->
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="resume-page"
          margin="0"
          page-height="{$page.height}"
          page-width="{$page.width}">
          <fo:region-body margin="0"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="resume-page">
        <fo:flow flow-name="xsl-region-body">
          <fo:table table-layout="fixed" width="100%" height="100%">
            <fo:table-column column-width="30%"/>
            <fo:table-column column-width="70%"/>
            <fo:table-body>
              <fo:table-row height="100%">
                <fo:table-cell background-color="#0F2D4A" color="white" padding="2em" padding-top="4em" vertical-align="top">
                  <fo:block font-family="{$body.font.family}" font-size="{$body.font.size}">
                    <!-- Left column content -->
                    <xsl:apply-templates select="r:resume/r:header"/>
                    <xsl:apply-templates select="r:resume/r:objective"/>
                    <xsl:apply-templates select="r:resume/r:academics/r:degrees/r:degree[2]"/>
                    <xsl:apply-templates select="r:resume/r:skillarea"/>
                    <xsl:apply-templates select="r:resume/r:memberships"/>
                    <xsl:apply-templates select="r:resume/r:misc"/>
                    <xsl:apply-templates select="r:resume/r:interests"/>
                    <xsl:apply-templates select="r:resume/r:pubs"/>
                    <xsl:apply-templates select="r:resume/r:awards"/>
                    <xsl:apply-templates select="r:resume/r:clearances"/>
                    <xsl:apply-templates select="r:resume/r:referees"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell padding="2em" padding-top="4em" vertical-align="top">
                  <fo:block font-family="{$body.font.family}" font-size="{$body.font.size}">
                    <!-- Right column content -->
                    <xsl:apply-templates select="r:resume/r:history"/>
                    <xsl:apply-templates select="r:resume/r:academics/r:degrees/r:degree[1]"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- Callable template to format a heading: -->
  <xsl:template name="heading">
    <xsl:param name="text">Heading Not Defined</xsl:param>
    <fo:block
      font-size="{$heading.font.size}"
      font-family="{$heading.font.family}"
      font-weight="bold"
      space-before="{$para.break.space}"
      space-after="{$para.break.space}"
      text-transform="uppercase"
      keep-with-next="always">
      <xsl:value-of select="$text"/>
    </fo:block>
  </xsl:template>
  
  <!-- Header information -->
  <xsl:template match="r:header" mode="standard">
    <fo:block space-after="2em">
      <fo:block
          font-weight="bold"
          font-size="20pt"
          text-transform="uppercase"
          text-align="center"
          space-after="1.0em">
        <xsl:apply-templates select="r:name"/>
      </fo:block>
      <fo:block
          font-size="14pt"
          text-align="center"
          space-after="2.0em">
        <xsl:text>Senior Haskell Developer</xsl:text>
      </fo:block>
      <!-- The provided PDF has a job title under the name. The standard
           XMLResume DTD doesn't have a place for it in the header.
           If your custom schema has one, you can add a template for it here.
           For example, if it's in <title>:
      <fo:block font-size="14pt" space-after="1em">
        <xsl:apply-templates select="r:title"/>
      </fo:block>
      -->
      
      <xsl:if test="r:contact/* or r:address/*">
        <fo:block>
            <xsl:call-template name="heading">
                <xsl:with-param name="text">Personal Details</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="r:contact"/>
            <xsl:apply-templates select="r:address"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="r:header" mode="centered">
     <xsl:apply-templates select="." mode="standard"/>
  </xsl:template>

  <xsl:template match="r:address" mode="free-form">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="r:address" mode="standard">
    <fo:block>
      <xsl:apply-templates select="r:city"/>
      <xsl:if test="r:country">
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="r:country"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="r:address" mode="european">
    <!-- Fallback to standard for simplicity -->
    <xsl:apply-templates select="." mode="standard"/>
  </xsl:template>

  <xsl:template match="r:address" mode="italian">
    <!-- Fallback to standard for simplicity -->
    <xsl:apply-templates select="." mode="standard"/>
  </xsl:template>

  <!-- Preserve line breaks within a free format address -->
  <xsl:template match="r:address//text()">
    <xsl:call-template name="String-Replace">
      <xsl:with-param name="Text" select="."/>
      <xsl:with-param name="Search-For">
        <xsl:text>&#xA;</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="Replace-With">
        <fo:block/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format contact information without labels -->
  <xsl:template match="r:contact/*">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Format the objective with the heading "Professional Objective." -->
  <xsl:template match="r:objective">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$objective.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the history with the heading "Employment History". -->
  <xsl:template match="r:history">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$history.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="r:location">
    <xsl:value-of select="$location.start"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$location.end"/>
  </xsl:template>

  <!-- Format a single job. -->
  <xsl:template match="r:job">
    <fo:block space-after="{$para.break.space}">
      <fo:block space-after="{$half.space}" keep-with-next="always">
        <fo:block
            keep-with-next="always"
            font-size="12pt"
            font-weight="bold">
          <xsl:apply-templates select="r:jobtitle"/>
        </fo:block>
        <fo:block keep-with-next="always">
          <xsl:apply-templates select="r:employer"/>
          <xsl:if test="r:location">
            <xsl:text> / </xsl:text>
            <xsl:apply-templates select="r:location"/>
          </xsl:if>
          <xsl:if test="r:date|r:period">
            <xsl:text> / </xsl:text>
            <xsl:apply-templates select="r:date|r:period"/>
          </xsl:if>
        </fo:block>
      </fo:block>
      <xsl:if test="r:description">
        <fo:block
          provisional-distance-between-starts="0.5em">
          <xsl:apply-templates select="r:description"/>
        </fo:block>
      </xsl:if>
      <xsl:if test="r:projects/r:project">
        <fo:block>
          <fo:block
              keep-with-next="always"
              font-style="{$job-subheading.font.style}"
              font-weight="{$job-subheading.font.weight}">
            <xsl:value-of select="$projects.word"/>
          </fo:block>
          <xsl:apply-templates select="r:projects"/>
        </fo:block>
      </xsl:if>
      <xsl:if test="r:achievements/r:achievement">
        <fo:block>
          <fo:block
              keep-with-next="always"
              font-style="{$job-subheading.font.style}"
              font-weight="{$job-subheading.font.weight}">
            <xsl:value-of select="$achievements.word"/>
          </fo:block>
          <xsl:apply-templates select="r:achievements"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format the projects section -->
  <xsl:template match="r:projects">
    <fo:list-block space-after="{$para.break.space}"
      provisional-distance-between-starts="{$para.break.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="r:project"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single project as a bullet -->
  <xsl:template match="r:project">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="text">
        <xsl:if test="@title">
          <xsl:value-of select="@title"/>
          <xsl:value-of select="$title.separator"/>
        </xsl:if>
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="r:achievements">
    <fo:list-block space-after="{$para.break.space}"
      provisional-distance-between-starts="{$para.break.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:for-each select="r:achievement">
        <xsl:call-template name="bulletListItem"/>
      </xsl:for-each>
    </fo:list-block>
  </xsl:template>

  <!-- Format academics -->
  <xsl:template match="r:academics">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">
        <xsl:value-of select="$academics.word"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="r:degrees"/>
    <fo:block
        font-weight="{$degrees-note.font.weight}"
        font-style="{$degrees-note.font.style}">
      <xsl:apply-templates select="r:note"/>
    </fo:block>
  </xsl:template>

  <!-- Format a single degree -->
  <xsl:template match="r:degree">
    <fo:block space-after="{$para.break.space}">
      <fo:block keep-with-next="always">
        <fo:block
            font-size="12pt"
            font-weight="bold">
          <xsl:apply-templates select="r:level"/>
          <xsl:if test="r:major">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$in.word"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="r:major"/>
          </xsl:if>
        </fo:block>
        <fo:block>
          <xsl:apply-templates select="r:institution"/>
          <xsl:if test="r:location">
            <xsl:text> / </xsl:text>
            <xsl:apply-templates select="r:location"/>
          </xsl:if>
          <xsl:if test="r:date|r:period">
            <xsl:text> / </xsl:text>
            <xsl:apply-templates select="r:date|r:period"/>
          </xsl:if>
        </fo:block>
      </fo:block>
      <xsl:apply-templates select="r:gpa"/>
      <xsl:if test="r:subjects/r:subject">
        <fo:block space-before="{$half.space}">
          <xsl:apply-templates select="r:subjects"/>
        </fo:block>
      </xsl:if>
      <xsl:if test="r:projects/r:project">
        <fo:block space-before="{$half.space}">
          <xsl:apply-templates select="r:projects"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format a GPA -->
  <xsl:template match="r:gpa">
    <fo:block space-before="{$half.space}">
      <fo:inline
          font-weight="{$gpa-preamble.font.weight}"
          font-style="{$gpa-preamble.font.style}">
        <xsl:choose>
          <xsl:when test="@type = 'major'">
            <xsl:value-of select="$major-gpa.word"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$overall-gpa.word"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:inline>

      <xsl:text>: </xsl:text>

      <xsl:apply-templates select="r:score"/>

      <xsl:if test="r:possible">
        <xsl:value-of select="$out-of.word"/>
        <xsl:apply-templates select="r:possible"/>
      </xsl:if>

      <xsl:if test="r:note">
        <xsl:text>. </xsl:text>
        <xsl:apply-templates select="r:note"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="r:subjects" mode="comma">
    <xsl:apply-templates select="r:subject" mode="comma"/>
    <xsl:value-of select="$subjects.suffix"/>
  </xsl:template>

  <xsl:template match="r:subject" mode="comma">
    <xsl:apply-templates select="r:title"/>
    <xsl:if test="$subjects.result.display = 1">
      <xsl:if test="r:result">
        <xsl:value-of select="$subjects.result.start"/>
        <xsl:value-of select="normalize-space(r:result)"/>
        <xsl:value-of select="$subjects.result.end"/>
      </xsl:if>   
    </xsl:if>   
    <xsl:if test="following-sibling::*">
      <xsl:value-of select="$subjects.separator"/>
    </xsl:if>
  </xsl:template>

  <!-- Format the subjects section as a list-block -->
  <xsl:template match="r:subjects" mode="table">
    <fo:list-block
      provisional-distance-between-starts="150pt"
      provisional-label-separation="0.5em"
    >
      <xsl:for-each select="r:subject">
        <fo:list-item>
          <fo:list-item-label
              end-indent="label-end()"
          >
            <fo:block>
              <xsl:apply-templates select="r:title"/>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body
              start-indent="body-start()"
          >
            <fo:block>
              <xsl:apply-templates select="r:result"/>
              <fo:leader leader-pattern="space" leader-length="2em"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:for-each>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="r:skillarea">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:apply-templates select="r:title"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="r:skillset"/>
  </xsl:template>

  <!-- Format a skillset's title (if any) and then the skills underneath it. -->
  <xsl:template match="r:skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
        <fo:block space-after="{$half.space}">
          <fo:inline
           font-style="{$skillset-title.font.style}"
           font-weight="{$skillset-title.font.weight}">
            <xsl:apply-templates select="r:title">
	      <xsl:with-param name="Separator" select="$title.separator"/>
	    </xsl:apply-templates>
          </fo:inline>
          <xsl:apply-templates select="r:skill" mode="comma"/>
          <!-- The following line should be removed in a future version. -->
          <xsl:apply-templates select="r:skills" mode="comma"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block
         keep-with-next="always"
         font-style="{$skillset-title.font.style}"
         font-weight="{$skillset-title.font.weight}">
          <xsl:apply-templates select="r:title"/>
        </fo:block>
        <xsl:if test="r:skill">
          <fo:list-block space-after="{$para.break.space}"
            provisional-distance-between-starts="{$para.break.space}"
            provisional-label-separation="{$bullet.space}">
            <xsl:apply-templates select="r:skill" mode="bullet"/>
          </fo:list-block>
        </xsl:if>

        <!-- The following block should be removed in a future version. -->
        <xsl:if test="r:skills">
          <fo:list-block space-after="{$para.break.space}"
            provisional-distance-between-starts="{$para.break.space}"
            provisional-label-separation="{$bullet.space}">
            <xsl:apply-templates select="r:skills" mode="bullet"/>
          </fo:list-block>
        </xsl:if>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Format a single skill as part of a comma-separated list. -->
  <xsl:template match="r:skill" mode="comma">
    <xsl:apply-templates/>
    <xsl:apply-templates select="@level"/>
    <xsl:choose>
      <xsl:when test="following-sibling::r:skill">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$skills.suffix"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Format a single skill as a bullet item. -->
  <xsl:template match="r:skill" mode="bullet">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="text">
        <xsl:apply-templates/>
        <xsl:apply-templates select="@level"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format a skill level -->
  <xsl:template match="r:skill/@level">
    <xsl:if test="$skills.level.display = 1">
      <xsl:value-of select="$skills.level.start"/>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:value-of select="$skills.level.end"/>
    </xsl:if>
  </xsl:template>


  <!-- Format a single bullet and its text -->
  <xsl:template name="bulletListItem">
    <xsl:param name="text"/>
    <fo:list-item>
      <!-- <fo:list-item-label start-indent="{$body.indent}" -->
      <!--   end-indent="label-end()"> -->
      <fo:list-item-label>
        <fo:block><xsl:value-of select="$bullet.glyph"/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:choose>
            <xsl:when test="string-length($text) > 0">
              <xsl:copy-of select="$text"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Format the publications section. -->
  <xsl:template match="r:pubs">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$publications.word"/></xsl:with-param>
    </xsl:call-template>
    <fo:list-block
        space-after="{$para.break.space}"
        provisional-distance-between-starts="{$para.break.space}"
        provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="r:pub"/>
    </fo:list-block>
  </xsl:template>
  
  <!-- Format a single publication -->
  <xsl:template match="r:pub">
    <fo:list-item>
      <fo:list-item-label start-indent="{$body.indent}"
        end-indent="label-end()">
        <fo:block><xsl:value-of select="$bullet.glyph"/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:call-template name="FormatPub"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Title of book -->
  <xsl:template match="r:bookTitle" priority="1">
    <fo:inline font-style="{$citation.font.style}"><xsl:apply-templates/></fo:inline><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Format memberships. -->
  <xsl:template match="r:memberships">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:apply-templates select="r:title"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="r:membership"/>
  </xsl:template>

  <!-- Format membership (can be used for Courses) -->
  <xsl:template match="r:membership">
    <fo:block space-after="{$para.break.space}">
      <fo:block font-weight="bold">
        <xsl:apply-templates select="r:title"/>
      </fo:block>
      <xsl:if test="r:organization">
        <fo:block>
          <xsl:apply-templates select="r:organization"/>
        </fo:block>
      </xsl:if>
      <xsl:if test="r:date|r:period">
        <fo:block>
          <xsl:apply-templates select="r:date|r:period"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format interests. -->
  <xsl:template match="r:interests">
    <!-- Heading -->
    <xsl:call-template name="heading">
      <xsl:with-param name="text">
        <xsl:call-template name="Title">
          <xsl:with-param name="Title" select="$interests.word"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Interests -->
    <xsl:apply-templates select="r:interest"/>
  </xsl:template>

  <!-- A single interest. -->
  <xsl:template match="r:interest">
    <fo:block space-after="{$half.space}">
        <xsl:apply-templates select="r:title"/>
        <xsl:if test="r:description">
          <fo:block>
             <xsl:apply-templates select="r:description"/>
          </fo:block>
        </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format an interest description -->
  <xsl:template match="r:interest/r:description">
      <xsl:for-each select="r:para">
        <fo:block space-after="{$half.space}">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:for-each>
  </xsl:template>
  
  <!-- Format security clearance section. -->
  <xsl:template match="r:clearances">
    <!-- Heading -->
    <xsl:call-template name="heading">
      <xsl:with-param name="text">
        <xsl:call-template name="Title">
          <xsl:with-param name="Title" select="$security-clearances.word"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
 
    <!-- Clearances -->
    <fo:list-block
        space-after="{$para.break.space}"
        provisional-distance-between-starts="{$para.break.space}"
        provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="r:clearance"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single security clearance. -->
  <xsl:template match="r:clearance">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="text">
        <fo:inline
            font-weight="{$clearance-level.font.weight}"
            font-style="{$clearance-level.font.style}">
          <xsl:apply-templates select="r:level"/>
        </fo:inline>
        <xsl:if test="r:organization">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="r:organization"/>
        </xsl:if>
        <xsl:if test="r:date|r:period">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="r:date|r:period"/>
        </xsl:if>
        <xsl:if test="r:note">
          <xsl:text>. </xsl:text>
          <xsl:apply-templates select="r:note"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format awards. -->
  <xsl:template match="r:awards">
    <!-- Heading -->
    <xsl:call-template name="heading">
      <xsl:with-param name="text">
        <xsl:call-template name="Title">
          <xsl:with-param name="Title" select="$awards.word"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <fo:list-block
        space-after="{$para.break.space}"
        provisional-distance-between-starts="{$para.break.space}"
        provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="r:award"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single award. -->
  <xsl:template match="r:award">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="text">
        <fo:inline font-weight="{$emphasis.font.weight}">
          <xsl:apply-templates select="r:title"/>
        </fo:inline>
        <xsl:if test="r:organization"><xsl:text>, </xsl:text></xsl:if>
        <xsl:apply-templates select="r:organization"/>
        <xsl:if test="r:date|r:period"><xsl:text>, </xsl:text></xsl:if>
        <xsl:apply-templates select="r:date|r:period"/>
        <xsl:apply-templates select="r:description"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format miscellaneous information with a title from the xml. -->
  <xsl:template match="r:misc">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="r:title"><xsl:value-of select="r:title"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$miscellany.word"/></xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="*[not(self::r:title)]"/>
  </xsl:template>

  <!-- Format the "last modified" date -->
  <xsl:template match="r:lastModified">
    <fo:block
        start-indent="{$heading.indent}"
        space-before="{$para.break.space}"
        space-after="{$para.break.space}"
        font-size="{$fineprint.font.size}">
      <xsl:value-of select="$last-modified.phrase"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
      <xsl:text>.</xsl:text>
    </fo:block>
  </xsl:template>

  <!-- Format legalese. -->
  <xsl:template match="r:copyright">
    <fo:block
        start-indent="{$heading.indent}"
        font-size="{$fineprint.font.size}">
      <fo:block keep-with-next="always">
        <xsl:value-of select="$copyright.word"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="r:year"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$by.word"/>
        <xsl:text> </xsl:text>
        <xsl:if test="r:name">
          <xsl:apply-templates select="r:name"/>
        </xsl:if>
        <xsl:if test="not(r:name)">
          <xsl:apply-templates select="/r:resume/r:header/r:name"/>
        </xsl:if>
        <xsl:text>. </xsl:text>
      </fo:block>
      <xsl:apply-templates select="r:legalnotice"/>
    </fo:block>
  </xsl:template>

  <!-- Format para's as block objects with 10pt space after them. -->
  <xsl:template match="r:para">
    <fo:block
        space-after="{$para.break.space}">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Format emphasized words in bold. -->
  <xsl:template match="r:emphasis">
    <fo:inline font-weight="{$emphasis.font.weight}">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <!-- Format citations to other works. -->
  <xsl:template match="r:citation">
    <fo:inline font-style="{$citation.font.style}">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <!-- Format a URL. -->
  <xsl:template match="r:url" name="FormatUrl">
    <fo:inline font-family="{$url.font.family}">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <!-- Format a period. -->
  <xsl:template match="r:period">
    <xsl:apply-templates select="r:from"/>&#x2013;<xsl:apply-templates select="r:to"/>
  </xsl:template>

  <!-- Format a date. -->
  <xsl:template match="r:date" name="FormatDate">
    <xsl:if test="r:dayOfMonth">
      <xsl:apply-templates select="r:dayOfMonth"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="r:month">
      <xsl:apply-templates select="r:month"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="r:year"/>
  </xsl:template>

  <!-- In a date with just "present", format it as the word "present". -->
  <xsl:template match="r:present"><xsl:value-of select="$present.word"/></xsl:template>

  <!-- Suppress items not needed for print presentation -->
  <xsl:template match="r:keywords"/>

  <!-- Format the referees -->
  <xsl:template match="r:referees">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$referees.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$referees.display = 1">
        <xsl:choose>
	  <xsl:when test="$referees.layout = 'compact'">
            <fo:table table-layout="fixed" width="90%">
	      <fo:table-column width="40%"/>
	      <fo:table-column width="40%"/>
	      <fo:table-body>
                <xsl:apply-templates select="r:referee" mode="compact"/>
	      </fo:table-body>
            </fo:table>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="r:referee" mode="standard"/>
          </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <fo:block space-after="{$para.break.space}">
          <xsl:value-of select="$referees.hidden.phrase"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Format a referee with the name, title, organiation in the 
       left column and the address in the right column -->
  <xsl:template match="r:referee" mode="compact">
    <fo:table-row>
      <fo:table-cell padding-bottom="{$half.space}">
        <fo:block
            font-style="{$referee-name.font.style}"
            font-weight="{$referee-name.font.weight}">
          <xsl:apply-templates select="r:name"/>
        </fo:block>
        <fo:block>
          <xsl:apply-templates select="r:title"/>
          <xsl:if test="r:title and r:organization">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="r:organization"/>
	</fo:block>
        <xsl:if test="r:contact">
          <fo:block>
            <xsl:apply-templates select="r:contact"/>
          </fo:block>
        </xsl:if>
      </fo:table-cell>
      <fo:table-cell padding-bottom=".5em">
        <xsl:if test="r:address">
          <fo:block>
            <xsl:apply-templates select="r:address"/>
          </fo:block>
        </xsl:if>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <!-- Format a referee as a block element -->
  <xsl:template match="r:referee" mode="standard">
    <fo:block space-after="{$para.break.space}">
      <fo:block space-after="{$half.space}">
        <fo:block keep-with-next="always"
            font-style="{$referee-name.font.style}"
            font-weight="{$referee-name.font.weight}">
          <xsl:apply-templates select="r:name"/>
        </fo:block>
        <fo:block>
          <xsl:apply-templates select="r:title"/>
          <xsl:if test="r:title and r:organization">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="r:organization"/>
        </fo:block>
      </fo:block>
      <xsl:if test="r:address">
        <fo:block space-after="{$half.space}">
          <xsl:apply-templates select="r:address"/>
        </fo:block>
      </xsl:if>
      <xsl:if test="r:contact">
        <fo:block space-after="{$half.space}">
          <xsl:apply-templates select="r:contact"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
