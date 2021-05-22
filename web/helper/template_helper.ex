defmodule MsqhPortal.TemplateHelper do
  def certificate(now, next_year, user, membership) do
    "<html>
    <link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u' crossorigin='anonymous'>
    <div class='container'>
          <div class='row'>
              <div class='col-md-4' >
                  <p >BPSBPSK</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-md-4'>

                  <p>SURAT TAWARAN CETAKAN KOMPUTER</p>
              </div>
              <div class='col-md-4'></div>
              <div class='col-sm-4'>
                  <p style='text-align: right;'>TARIKH CETAKAN : {{date}}</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-3'>
                  <img src='http://www.nre.gov.my/_catalogs/masterpage/Nreportal/images/MasterPage/logo-jata.png'>
              </div>
              <div class='col-sm-9'>
                  <br/>
                  <p><b>KEMENTERIAN PENDIDIKAN MALAYSIA</b>
                      <br/>(Ministry of Education Malaysia)
                      <br/><b>BAHAGIAN PENGURUSAN SEKOLAH BERASRAMA PENUH DAN SEKOLAH KECEMERLANGAN</b>
                      <br/>(Fully Residential And Excellent Schools Management Division)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style='text-align: right; font-size: 10px;'>Tel : +603-8321 7400 (Talian Umum)</span>
                      <br/>ARAS 3, Blok 2251, JALAN USAHAWAN 1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style='text-align: right; font-size: 10px;'>Fax : +603-8321 7403</span>
                      <br/>63000 CYBERJAYA, SELANGOR&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style='text-align: right; font-size: 10px;'>Web : http://www.moe.gov.my</span></p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-offset-8'>
                  <p>Ruj. Kami : KPMSP.800-1/1/12/B012011208</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-6'>
                  <b>{{peribadi.nama}}</b>
                  <br/>
                  <b>(A/G : {{peribadi.agiliran}})</b>
                  <br/>
                  {{#if peribadi.alamat1}}
                  <b>{{peribadi.alamat1}}, {{peribadi.alamat2}}</b>
                  <br/>
                  <b>{{peribadi.poskod}}</b><b>{{peribadi.bandar}}</b>
                  <br/>
                  <b>{{peribadi.poskod}}</b>
                  <br/>
                  {{else}}
                  <br/>
                  {{/if}}
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-12'>
                  <b>TAWARAN KEMASUKAN KE TINGKATAN EMPAT (4) SEKOLAH BERASRAMA PENUH TAHUN
      2016</b>
                  <br/>
                  <p style='text-align: justify;'>Tahniah, anda ditawarkan ke Tingkatan Empat (4) di Sekolah Berasrama Penuh, Kementerian Pendidikan Malaysia bagi sesi persekolahan tahun 2016.</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-8 col-sm-offset-4'>
                  <div class='row'>
                      <div class='col-sm-7'>
                          <b>{{peribadi.nama_sbp}}</b>
                          <b>{{peribadi.alamaat_sbp}}</b>
                          <p>NO. TELEFON : <b>{{peribadi.kodtel}}-{{peribadi.notel}}</b>
                              <br/> ALIRAN : <b>{{peribadi.ket_aliran}}</b>
                              <br/> TARIKH PENDAFTARAN : 22 MAC 2016<b></b>
                              <br/> MASA : <b>9.00 PAGI</b></p>
                          <br/>
                      </div>
                  </div>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-12'>
                  <p style='text-align: justify;'>2. Tawaran ini adalah muktamad. Sebarang permohonan untuk bertukar aliran yang ditawarkan atau ke Sekolah Berasrama Penuh lain tidak akan dipertimbangkan.</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-12'>
                  <p style='text-align: justify;'> 3. Tawaran ini hanya sah sekiranya anda memenuhi syarat-syarat kemasukan yang dinyatakan dalam Buku Tawaran Kemasukan Murid Tingkatan 4. Tawaran ini juga akan terbatal sekiranya anda tidak mendaftar dalam masa <b>tujuh (7) hari</b> dari tarikh pendaftaran.</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-12'>
                  <p style='text-align: justify;'>
                      4. Bahagian ini berhak membatalkan tawaran ini sekiranya maklumat yang diberikan tidak benar.</p>
              </div>
          </div>
          <div class='row'>
              <div class='col-sm-12'>
                  <p>Sekian. Terima kasih.
                  </p>
              </div>
          </div>
          <br/>
          <br/>
          <b>
                      'BERKHIDMAT UNTUK NEGARA'</b>
          <p>Saya yang menurut perintah,</p>
          <br/>
          <br/>
          <br/>
          <p><b>DATO' HAJAH RASHIDAH BINTI MD ARIF</b>
              <br/> Bahagian Pengurusan Sekolah Berasrama Penuh
              <br/> dan Sekolah Kecemerlangan
              <br/> b.p. Ketua Setiausaha
              <br/> Kementerian Pendidikan Malaysia</p>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <p style='text-align: center;'>Surat ini adalah cetakan komputer dan tandatangan tidak diperlukan</p>
      </div>
      </html>"
  end
end
